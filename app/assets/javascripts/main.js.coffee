logError = () -> console.log("Error: ", arguments)
audio = null
wavesurfer = null
scroller = null
bezier = null
$ ->
  paper.install(window);
  scroller = document.querySelector("#waveform-scroller")
  bezier = new BezierLevel document.querySelector(".controls")
  window.level = bezier
  waveform = document.querySelector("#waveform")


  zoom = (factor) ->
    oldW = parseInt(waveform.style.width)
    newW = oldW * factor
    newW = Math.max(window.innerWidth, newW)
    waveform.style.width = (newW) + "px"
    wavesurfer.drawBuffer()
    return newW / window.innerWidth
  $(document.body).on "mousewheel", (e) ->
    if e.ctrlKey
      e.preventDefault()
      factor = if e.originalEvent.wheelDelta > 0 then 1.1 else 0.9
      scale = zoom(factor)
      bezier.setScale(scale)
    else
      scroller.scrollLeft -= e.originalEvent.wheelDeltaX
      bezier.scroll e.originalEvent.wheelDeltaX




  $(document.body).on "dragover", (e) ->
    e.preventDefault()
    document.body.classList.add("dragover")

  $(document.body).on "dragleave", (e) ->
    e.preventDefault()
    document.body.classList.remove("dragover")

  $(document.body).on "drop", (e) ->
    e.preventDefault()
    document.body.classList.remove("dragover")
    file = e.originalEvent.dataTransfer.files[0]
    storeFile(file)
    audioURL = URL.createObjectURL(file)
    localStorage.setItem("last-audio", audioURL)
    loadAudioFile(audioURL)

  loadAudioFile = (audioURL) ->
    wavesurfer = Object.create(WaveSurfer)
    wavesurfer.init({
      container: '#waveform',
      waveColor: 'violet',
      progressColor: 'purple'
    });
    waveform.style.width = window.innerWidth + "px"
    wavesurfer.on 'ready', () ->
      wavesurfer.play()
    wavesurfer.load(audioURL);
    window.wavesurfer = wavesurfer

  loadLastFile = () ->
    webkitRequestFileSystem PERSISTENT, 1024*1024*300, (storage) ->
      storage.root.getFile "/audio.mp3", {}, (f) ->
        loadAudioFile(f.toURL())
  loadLastFile()

  storeFile = (file) ->
    afterQuota = () ->
      console.log("Store ", file)
      webkitRequestFileSystem PERSISTENT, 1024*1024*300, (storage) ->
        console.log("Storage ", storage)
        storage.root.getFile "/audio.mp3", {create:true}, (dest) ->
          console.log("Dest", dest)
          dest.createWriter (writer) ->
            console.log("Writer", writer)
            writer.write(file)
    webkitStorageInfo.requestQuota webkitStorageInfo.PERSISTENT, 1024 * 1024 * 30, afterQuota, logError
