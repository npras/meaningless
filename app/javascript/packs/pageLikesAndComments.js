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
  

  function appendAdjacentHtmlToNode(selector, html, position='beforeend') {
    document
      .querySelector(selector)
      .insertAdjacentHTML(position, html)
  }


  function setupStyleHtml() {
    const styleHtml = `
    <style>
      #page-likes-and-comments .submit-button {
        background-color: #f44336;
        border: none;
        color: white;
        padding: 10px 15px;
        text-align: center;
        text-decoration: none;
        display: inline-block;
        font-size: 1.1em;
        margin: 4px 2px;
        cursor: pointer;
      }

      #page-likes-and-comments button#like-button {
        background-color: teal;
        border: none;
        color: white;
        padding: 3px 5px;
        text-align: center;
        text-decoration: none;
        display: inline-block;
        font-size: 1.1em;
        margin: 4px 2px;
        cursor: pointer;
      }

      #page-likes-and-comments .submit-button:disabled,
      #page-likes-and-comments #like-button:disabled {
        background-color: gray;
      }

      #page-likes-and-comments #likes-count {
        display: inline-block;
        vertical-align: top;
        margin-top: 8px;
        margin-left: 3px;
        font-family: 'Source Sans Pro',sans-serif;
        font-weight: 600;
        color: #fbb73e;
        color: #000;
      }
    <style>
    `
    appendAdjacentHtmlToNode('#page-likes-and-comments', styleHtml, 'afterbegin')
  }


  function setupLikeHtml() {
    const likeHtml = `
       <section id="page-likes">
         <span><button id="like-button">Like</button></span>
         <span id="likes-count">0</span>
       </section>
    `
    appendAdjacentHtmlToNode('#page-likes-and-comments', likeHtml)
  }


  function setupCommentFormAndListHtml() {
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


  function setupPlaceholdersForLikesAndComments() {
    setupStyleHtml()
    setupLikeHtml()
    setupCommentFormAndListHtml()
  }


  function handleResponseIfNotOk(response, url) {
    if (!response.ok) {
      throw new Error(`Response status: ${response.status}. Something wrong with ${url}!`)
    }
  }


  // July 6, 2019
  function fuckingStrftime(d) {
    return `${d.toLocaleString('en-us', { month: 'long' })} ${d.getDate()}, ${d.getFullYear()}`
  }


  // <li id="comment-628415769">
  //   <cite>
  //     Avdi Grimm (July 6, 2019)
  //     <a href="#comment-628415769">#</a>
  //   </cite>

  //   <p>This is a wonderful post!</p>
  // </li>
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
      handleResponseIfNotOk(response, apiUrl)
      let responseJson = await response.json()
      return responseJson
    }

    const showLikesAndComments = json => {
      const { likes, comments } = json
      let commentsLiHtml = comments.map(c => makeLiHtmlForComment(c)).join('')
      const commentsHtml = `<ol> ${commentsLiHtml} </ol>`
      document.querySelector('#page-likes > #likes-count').innerText = likes
      document.querySelector('#page-comments > #comments-list').innerHTML = commentsHtml
    }

    getLikesAndComments()
      .then(showLikesAndComments)
  }


  function handleLikeEvent() {
    const likeBtnNode = document.getElementById('like-button')
    likeBtnNode.innerText = "Liking..."
    likeBtnNode.disabled = true
    const postLike = async () => {
      let response = await fetch(_CREATE_LIKE_URL, {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ url: _CURRENT_PAGE_URL })
      })
      handleResponseIfNotOk(response, _CREATE_LIKE_URL)
      let responseJson = await response.json()
      return responseJson
    }

    postLike()
      .then(json => {
        document.querySelector('#page-likes > #likes-count').innerText = json.likes
      })
      .catch(error => console.log(error) )
      .then(() => {
        likeBtnNode.innerText = "Like"
        likeBtnNode.disabled = false
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
      handleResponseIfNotOk(response, apiUrl)
      let responseJson = await response.json()
      return responseJson
    }

    postComment()
      .then(json => {
        if (json.comment) {
          const commentHtml = makeLiHtmlForComment(json.comment)
          appendAdjacentHtmlToNode('#comments-list > ol', commentHtml)
        } else {
          console.log("Probably a spam comment 👺.")
        }
      })
      .catch(error => console.log(error) )
      .then(() => {
        formNode.reset()
        formNode.submit.value = 'Submit comment'
        formNode.submit.disabled = false
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
