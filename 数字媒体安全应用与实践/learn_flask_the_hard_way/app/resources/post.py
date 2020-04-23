from flask import request, current_app, flash, redirect, url_for
from flask_login import current_user
from flask_restful import Resource, reqparse

from werkzeug.datastructures import FileStorage
from werkzeug.utils import secure_filename
from datetime import datetime
from pathlib import Path

from app.post.models import Post
from app.extensions import marshmallow, db
from app.utils.paginate import paginate


class PostSchema(marshmallow.ModelSchema):

    id = marshmallow.Int(dump_only=True)

    class Meta:
        model = Post
        sql_session = db.session


class PostResource(Resource):
    # method_decorators = [jwt_required]

    def get(self, post_id):
        schema = PostSchema()
        post = Post.query.get_or_404(post_id)
        return {"post": schema.dump(user).data}

    def put(self, post_id):
        schema = PostSchema(partial=True)
        post = Post.query.get_or_404(post_id)
        post, errors = schema.load(request.json, instance=post)
        if errors:
            return errors, 422

        db.session.commit()

        flash('修改成功！')
        return redirect(url_for('home.index'))

    def delete(self, post_id):
        post = post.query.get_or_404(post_id)
        db.session.delete(post)
        db.session.commit()

        flash('删除成功！')
        return redirect(url_for('home.index'))
        


post_parser = reqparse.RequestParser()
post_parser.add_argument('text', type=str, location='form')
post_parser.add_argument('image', type=FileStorage, location='files')

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1] in ['jpg', 'jpeg', 'png']


class PostList(Resource):
    # method_decorators = [jwt_required]

    def get(self):
        schema = PostSchema(many=True)
        query = Post.query
        return paginate(query, schema)

    def post(self):
        schema = PostSchema()

        args = post_parser.parse_args()

        text = args.get('text')
        if text is None:
            text = ''

        image = request.files['image']
        if not image:
            flash('必须添加图片！')
            return redirect(url_for('home.index'))  #422

        if not allowed_file(image.filename):
            flash('仅支持 jpeg、jpg、png 图片！')
            return redirect(url_for('home.index'))  #422

        file_name = str(int(datetime.now().timestamp() *
                            1000)) + '-' + secure_filename(image.filename)

        image.save(str(Path(current_app.config['UPLOAD_FOLDER']) / file_name))
        post = Post(user_id=current_user.id,
                    user_name=current_user.name,
                    text=text,
                    image=file_name)

        db.session.add(post)
        db.session.commit()

        flash('发布成功！')
        return redirect(url_for('home.index'))  #201