/**
 * Created by hacker on 2017/10/15.
 */

$(function() {
  const posts_div = document.querySelector("#posts");

  fetch("/api/posts")
    .then(function(response) {
      return response.json();
    })
    .then(function(posts) {
      // if(posts.pages > 1){
      //   posts_div.insertAdjacentHTML("afterend","<div id='buttons'></div");
      //   $buttons = "<input type='button' value='&lt;&lt; 上一页' onclick='"+ posts.prev +"'>";
      //   $buttons += "<input type='button' value='下一页 &gt;&gt;' onclick='"+ posts.next +"'>";
      //   document.getElementById("buttons").innerHTML = $buttons;
      // }
      $.each(posts.results, function(index, post) {
        console.log(post);
        let item =
          '<article class="blog-post">' +
          "<header>" +
          "<h2>" +
          post.user_name +
          "</h2>" +
          "</header>" +
          "<div>" +
          "<p>" +
          post.text +
          "</p>" +
          "</div>" +
          "<div>" +
          '<img class="image" src="/images/' +
          post.image +
          '">' +
          "</div>" +
          "</article>";
        posts_div.insertAdjacentHTML("beforeend", item);
      });
    });
});
