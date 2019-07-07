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

  function showCommentForm() {
    const html = `
      <header id="comment-form-section">
        <h4>Leave a comment</h4>

        <form id="comment-form" action="${apiUrl}/api/discussion_comments" method="post">
          <input type="hidden" name="url" value="${currentPageUrl}" />

          <div>
            <label for="author_name">Your Name</label>         
            <br>
            <input type="text" name="comment[author_name]" id="author_name" required value="" />
          </div>

          <div>
            <label for="email">Your Email &nbsp;
              <span class="small">(private for my eyes only)</span>
            </label>         
            <br>
            <input type="email" name="comment[email]" id="email" value="" required />
          </div>

          <div>
            <label for="comment">Comment</label>         
            <br>
            <textarea id="comment" name="comment[body]" cols="80" rows="10" required></textarea>
          </div>

          <div>
            <input type="submit" name="submit" class="submit-button" value="Submit comment">
          </div>
        </form>

      </header>

      <h3>Comments</h3>
      <div id="comments-list"></div>
    `
		document.getElementById('page-comments').innerHTML = html
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

  function handleSubmitCommentEvent(e) {
    e.preventDefault()
    const formNode = document.getElementById('comment-form')
    formNode.submit.disabled = true
    const postComment = async () => {
      const formData = new FormData(formNode)
      const commentUrl = new URL(`${apiUrl}/api/discussion_comments`)
      let response = await fetch(commentUrl, {
        method: 'POST',
        body: formData
      })
      if (!response.ok) {
        console.log(`Some problem with the ${commentUrl} page! So what?`)
        throw new Error(response.status)
      }
      let data = await response.text()
      return data
    }

    postComment()
      .then(html => {
        if (html.length > 0) {
          formNode.reset()
          formNode.submit.disabled = false
          document
            .querySelector('#comments-list > ol')
            .insertAdjacentHTML('beforeend', html)
        } else {
          console.log("something fishy")
        }
      })
  }

  function setupAbilityToComment() {
    document
      .getElementById('comment-form')
      .addEventListener("submit", handleSubmitCommentEvent)
  }

  function init() {
    showLikeWidget()
    showCommentForm()
    //showLikesCount()
    //showComments()
    showLikesCountAndComments()

    setupAbilityToLike()
    setupAbilityToComment()
  }

  // bootloader
  init()

}())
