(function() {
  var lists = document.querySelectorAll("[data-writing-list]");

  if (!lists.length || !window.fetch) {
    return;
  }

  function createPostItem(post) {
    var item = document.createElement("li");
    var link = document.createElement("a");
    var date = document.createElement("span");
    var title = document.createElement("span");

    link.className = "plain";
    link.href = post.url;

    date.className = "index-date muted small font-ui";
    date.textContent = post.date;

    title.className = "index-title";
    title.textContent = post.title;

    link.append(date, title);
    item.appendChild(link);

    return item;
  }

  function renderList(list, posts) {
    list.replaceChildren();
    posts.forEach(function(post) {
      if (post && post.title && post.url && post.date) {
        list.appendChild(createPostItem(post));
      }
    });
  }

  var endpoint = lists[0].getAttribute("data-writing-endpoint") || "/writing.json";
  var separator = endpoint.indexOf("?") === -1 ? "?" : "&";

  fetch(endpoint + separator + "fresh=" + Date.now(), { cache: "no-store" })
    .then(function(response) {
      if (!response.ok) {
        throw new Error("Could not refresh writing list");
      }

      return response.json();
    })
    .then(function(posts) {
      if (!Array.isArray(posts)) {
        return;
      }

      lists.forEach(function(list) {
        renderList(list, posts);
      });
    })
    .catch(function() {
      // Static HTML stays as the fallback if refresh fails.
    });
})();
