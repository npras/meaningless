(function(){

  console.log('loaded from server changed!');

  function showCommentForm() {
    return `
      <header>
        <h4>Leave a comment</h4>

        <form action="http://localhost:3000/api/v1/comments" method="post">
          <label for="author_name">Your Name</label>         
          <input type="text" name="author_name" id="author_name" value="" />

          <label for="email">Your Email &nbsp;
            <span class="small">(private for my eyes only)</span>
          </label>         
          <input type="email" name="email" id="email" value="" />

          <label for="comment">Comment</label>         
          <textarea id="comment" name="comment" cols="80" rows="10"></textarea>

          <input type="submit" name="submit" value="Submit comment>
        </form>

      </header>

      <h3>Comments</h3>
      <div id="comments"></div>
    `;
  }

  function showLikeForm() {
    const html = `
       <span>
         <i id="likes-button">star</i>
         <span id="likes-count">0</span>
       </span>
    `;

		document.getElementById('page-likes').innerHTML = html
  }

  function showLikesCount() {
    const currentPageUrl = window.location.href

    const getLikes = async () => {
      const url = new URL('http://localhost:3000/api/discussion_likes')
      let params = { url: currentPageUrl }
      url.search = new URLSearchParams(params)
      let response = await fetch(url);
      if (!response.ok) {
        console.log("Some problem with the `${url}` page! So what?")
        throw new Error(response.status)
      }
      let data = await response.text()
      return data;
    }

    getLikes()
      .then(data => {
        window.likesCount = data
        document.querySelector('span#likes-count').innerText = data
      })
  }

  function init() {
    showLikeForm()
    showLikesCount()

    document.getElementById('likes-button').addEventListener("click", function() {
      console.log('clickd!')
    })

  }

  // bootloader
  init()

}())
