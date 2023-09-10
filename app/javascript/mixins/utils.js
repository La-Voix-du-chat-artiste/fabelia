const fadeIn = function fadeIn(element, duration, callback = () => {}) {
  element.style.opacity = 0
  var start = performance.now()

  function fadeInAnimation(timestamp) {
     var currentTime = timestamp - start
     var progress = currentTime / duration
     element.style.opacity = Math.min(progress, 1)

     if (currentTime < duration) {
        window.requestAnimationFrame(fadeInAnimation)
     } else if (callback) {
        callback()
     }
  }

  window.requestAnimationFrame(fadeInAnimation)
}

const fadeOut = function fadeOut(element, duration, callback) {
  var start = performance.now()

  function fadeOutAnimation(timestamp) {
     var currentTime = timestamp - start
     var progress = currentTime / duration
     element.style.opacity = Math.max(1 - progress, 0)

     if (currentTime < duration) {
        window.requestAnimationFrame(fadeOutAnimation)
     } else {
        element.style.display = 'none'
        if (callback) {
           callback()
        }
     }
  }

  window.requestAnimationFrame(fadeOutAnimation)
}

export { fadeIn, fadeOut }
