from pathlib import Path

import requests
from bs4 import BeautifulSoup

from image import embed_watermark


def send_post(username, password, text, file_path, url):
    s = requests.session()

    r = s.get(url + '/auth/login')
    soup = BeautifulSoup(r.text, 'html.parser')

    csrf_token = soup.find(id="csrf_token")['value']

    params = {
        'email': username,
        'password': password,
        'csrf_token': csrf_token
    }
    r = s.post(url + '/auth/login', data=params)
    if not r.status_code == 200:
        print('Login failed.')
        return

    image = Path(file_path)
    from_data = {'text': text}
    file = {'image': (image.name, open(image, 'rb'))}

    r = s.post(url + '/api/posts', data=from_data, files=file)
    if not r.status_code == 200:
        print('Upload post failed.')
        return


if __name__ == '__main__':
    username = 'jckling@163.com'
    password = 'password'

    text = 'Test'
    image_file = r'octocat.jpg'
    url = 'http://127.0.0.1:5000'

    new_image = Path(image_file).with_name('embed.jpg')

    embed_watermark(image_file, 'hello,world!', str(new_image))

    send_post(username, password, text, str(new_image), url)
