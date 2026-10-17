const slug = decodeURI(location.pathname).replace(/^\/+|\/+$/g, "");
document.getElementById("title").textContent = slug;
