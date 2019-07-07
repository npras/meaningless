(function(){


  const _API_URL = "http://localhost:3000"
  const _GET_LIKES_AND_COMMENTS_URL = `${_API_URL}/api/discussion_likes_and_comments`
  const _CREATE_LIKE_URL = `${_API_URL}/api/discussion_like`
  const _CREATE_COMMENT_URL = `${_API_URL}/api/discussion_comment`

  const _CURRENT_PAGE_URL = window.location.href


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

      let commentsLiHtml = comments.map(comment => (`
            <li id="comment-${comment.id}">
              <cite>
                ${comment.name} (${comment.created_at})
                <a href="#comment-${comment.id}">#</a>
              </cite>

              <p>${comment.body}</p>
            </li>
          `)).join('')
      const commentsHtml = `<ol> ${commentsLiHtml} </ol>`
      document.querySelector('#page-comments > #comments-list').innerHTML = commentsHtml
    }

    getLikesAndComments().then(showLikesAndComments)
  }


  function handleLikeEvent() {
    const postLike = async () => {
    }
  }


  function handleSubmitCommentEvent() {}


  function setupAbilityToLikeAndComment() {
    document
      .getElementById('like-button')
      .addEventListener("click", handleLikeEvent)

    document
      .getElementById('comment-form')
      .addEventListener("submit", handleSubmitCommentEvent)
  }


  (function init() {
    setupPlaceholdersForLikesAndComments()
    getAndShowLikesAndComments()
    setupAbilityToLikeAndComment()
  })()


}())

