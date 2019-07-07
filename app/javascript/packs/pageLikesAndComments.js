(function(){


  const _API_URL = "http://localhost:3000"
  const _GET_LIKES_AND_COMMENTS_URL = `${_API_URL}/api/discussion_likes_and_comments`
  const _CREATE_LIKE_URL = `${_API_URL}/api/discussion_like`
  const _CREATE_COMMENT_URL = `${_API_URL}/api/discussion_comment`

  const _CURRENT_PAGE_URL = window.location.href




  function escapeHtml(unsafe) {
    return unsafe
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;")
  }
  

  function appendAdjacentHtmlToNode(selector, html) {
    document
      .querySelector(selector)
      .insertAdjacentHTML('beforeend', html)
  }


  function setupPlaceholdersForLikesAndComments() {
    const likeHtml = `
       <section id="page-likes">
         <i id="like-button">star</i>
         <span id="likes-count">0</span>
       </section>
    `
    appendAdjacentHtmlToNode('#page-likes-and-comments', likeHtml)

    const commentFormAndListHtml = `
      <section id="page-comments">
        <h4>Leave a comment</h4>

        <form id="comment-form" action="${_API_URL}/api/discussion_comment" method="post">
          <input type="hidden" name="url" value="${_CURRENT_PAGE_URL}" />

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

        <h4>Comments</h4>
        <div id="comments-list"></div>
      </section>
    `
    appendAdjacentHtmlToNode('#page-likes-and-comments', commentFormAndListHtml)
  }


  function handleNonOkResponse(response, url) {
    if (!response.ok) {
      console.log(`Some problem with the ${url} page!`)
      console.log(JSON.stringify(response))
      throw new Error(response.status)
    }
  }


  function fuckingStrftime(d) {
    return `${d.toLocaleString('en-us', { month: 'long' })} ${d.getDate()}, ${d.getFullYear()}`
  }


  function makeLiHtmlForComment(comment) {
    return `
      <li id="comment-${comment.id}">
        <cite>
          ${escapeHtml(comment.name)} (${fuckingStrftime(new Date(comment.created_at))})
          <a href="#comment-${comment.id}">#</a>
        </cite>

        <p>${escapeHtml(comment.body)}</p>
      </li>
    `
  }

  function getAndShowLikesAndComments() {
    const getLikesAndComments = async () => {
      const apiUrl = new URL(_GET_LIKES_AND_COMMENTS_URL)
      let params = { url: _CURRENT_PAGE_URL }
      apiUrl.search = new URLSearchParams(params)
      let response = await fetch(apiUrl)
      handleNonOkResponse(response, apiUrl)
      let responseJson = await response.json()
      return responseJson
    }

    const showLikesAndComments = json => {
      const { likes, comments } = json
      document.querySelector('#page-likes > #likes-count').innerText = likes

      let commentsLiHtml = comments.map(c => makeLiHtmlForComment(c)).join('')
      const commentsHtml = `<ol> ${commentsLiHtml} </ol>`
      document.querySelector('#page-comments > #comments-list').innerHTML = commentsHtml
    }

    getLikesAndComments().then(showLikesAndComments)
  }


  function handleLikeEvent() {
    const postLike = async () => {
      let response = await fetch(_CREATE_LIKE_URL, {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ url: _CURRENT_PAGE_URL })
      })
      handleNonOkResponse(response, _CREATE_LIKE_URL)
      let responseJson = await response.json()
      return responseJson
    }

    postLike()
      .then(json => {
        document.querySelector('#page-likes > #likes-count').innerText = json.likes
      })
  }


  function handleSubmitCommentEvent(e) {
    e.preventDefault()
    const formNode = document.getElementById('comment-form')
    formNode.submit.value = "Submitting..."
    formNode.submit.disabled = true

    const postComment = async () => {
      const formData = new FormData(formNode)
      const apiUrl = new URL(_CREATE_COMMENT_URL)
      let response = await fetch(apiUrl, {
        method: 'POST',
        body: formData
      })
      handleNonOkResponse(response, apiUrl)
      let responseJson = await response.json()
      return responseJson
    }

    postComment()
      .then(json => {
        formNode.reset()
        formNode.submit.value = 'Submit comment'
        formNode.submit.disabled = false
        if (json.comment) {
          const commentHtml = makeLiHtmlForComment(json.comment)
          appendAdjacentHtmlToNode('#comments-list > ol', commentHtml)
        } else {
          console.log("Probably a spam comment.")
        }
      })
  }


  function setupAbilityToLikeAndComment() {
    document
      .getElementById('like-button')
      .addEventListener("click", handleLikeEvent)

    document
      .getElementById('comment-form')
      .addEventListener("submit", handleSubmitCommentEvent)
  }


  // initializer
  (function () {
    setupPlaceholdersForLikesAndComments()
    getAndShowLikesAndComments()
    setupAbilityToLikeAndComment()
  })()


}())
