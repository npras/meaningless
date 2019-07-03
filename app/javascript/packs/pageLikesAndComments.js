(function(){

  const apiUrl = "http://localhost:3000"
  const currentPageUrl = window.location.href

  console.log(`Script loaded from ${apiUrl}!`)

  function showLikeWidget() {
    const html = `
       <span>
         <i id="likes-button">star</i>
         <span id="likes-count">0</span>
       </span>
    `;

		document.getElementById('page-likes').innerHTML = html
  }

  function showLikesCount() {
    const getLikes = async () => {
      const likesUrl = new URL(`${apiUrl}/api/discussion_likes`)
      let params = { url: currentPageUrl }
      likesUrl.search = new URLSearchParams(params)
      let response = await fetch(likesUrl);
      if (!response.ok) {
        console.log(`Some problem with the ${likesUrl} page! So what?`)
        throw new Error(response.status)
      }
      let data = await response.json()
      return data
    }

    getLikes()
      .then(json => {
        // console.log(JSON.stringify(json))
        if (json.error) {
          console.log(json.error)
        } else {
          //window.likesCount = json.likes
          document.querySelector('span#likes-count').innerText = json.likes
        }
      })
  }

  function handleLikeEvent() {
    const postLike = async () => {
      const likesUrl = `${apiUrl}/api/discussion_likes`
      let response = await fetch(likesUrl, {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ url: currentPageUrl })
      })
      if (!response.ok) {
        console.log(`Some problem with the ${likesUrl} page! So what?`)
        throw new Error(response.status)
      }
      let data = await response.json()
      return data
    }

    postLike()
      .then(json => {
        if (json.error) {
          console.log(json.error)
        } else {
          //window.likesCount = json.likes
          document.querySelector('span#likes-count').innerText = json.likes
        }
      })
  }

  function setupAbilityToLike() {
    document
      .getElementById('likes-button')
      .addEventListener("click", handleLikeEvent)
  }

  function showCommentForm() {
    const html = `
      <header id="comment-form">
        <h4>Leave a comment</h4>

        <form action="${apiUrl}/api/discussion_comments" method="post">
          <div>
            <label for="author_name">Your Name</label>         
            <br>
            <input type="text" name="author_name" id="author_name" value="" />
          </div>

          <div>
            <label for="email">Your Email &nbsp;
              <span class="small">(private for my eyes only)</span>
            </label>         
            <br>
            <input type="email" name="email" id="email" value="" />
          </div>

          <div>
            <label for="comment">Comment</label>         
            <br>
            <textarea id="comment" name="comment" cols="80" rows="10"></textarea>
          </div>

          <div>
            <input type="submit" name="submit" value="Submit comment">
          </div>
        </form>

      </header>

      <h3>Comments</h3>
      <div id="comments-list"></div>
    `
		document.getElementById('page-comments').innerHTML = html
  }

  function showComments() {
    const getComments = async () => {
      const commentsUrl = new URL(`${apiUrl}/api/discussion_comments`)
      let params = { url: currentPageUrl }
      commentsUrl.search = new URLSearchParams(params)
      let response = await fetch(commentsUrl);
      if (!response.ok) {
        console.log(`Some problem with the ${commentsUrl} page! So what?`)
        throw new Error(response.status)
      }
      let data = await response.text()
      return data
    }

    getComments()
      .then(text => {
        document.querySelector('#comments-list').innerHTML = text
      })
  }

  function init() {
    // setup likes
    showLikeWidget()
    showLikesCount()
    setupAbilityToLike()

    // setup comments
    showCommentForm()
    showComments()
    //setupAbilityToComment()
  }

  // bootloader
  init()

}())
