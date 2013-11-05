class Theme
  # Class methods
  @events: (events) ->
    @::events ?= {}
    @::events = $.extend({}, @::events) unless @::hasOwnProperty "events"
    #@::events[key] = value for key, value of events
    @::events = $.extend(true, {}, @::events, events)
  
  @onDomReady: (initializers) ->
    @::onDomReady ?= []  
    @::onDomReady = @::onDomReady[..] unless @::hasOwnProperty "onDomReady"
    @::onDomReady.push initializer for initializer in initializers
  
  constructor: ->
    @_setupEventListeners()
    
  domReady: ->
    @_loadOnDomReadyMethods()
  
  _loadOnDomReadyMethods: ->
    for callback in @onDomReady
      @[callback]()
    
  _setupEventListeners: =>
    $document = $(document)
    for selector, actions of @events
      for action, callback of actions
        $document.on(action, selector, @[callback])

class DefaultTheme extends Theme
  @events

  
  @onDomReady [

  ]

class SpecificTheme extends DefaultTheme
  @events
    # '#element' : event : 'functionName'
  
  @onDomReady [
    #'functionName'
    'drawGlobe'
  ]
  
  # Define functions here

  drawGlobe: ->
    renderer = new THREE.WebGLRenderer()
    renderer.setSize(window.innerWidth, window.innerHeight)
    renderer.shadowMapEnabled = true
    document.body.appendChild(renderer.domElement)

    pi = Math.PI
    deg = pi/180

    scene = new THREE.Scene()
    camera = new THREE.PerspectiveCamera(75, window.innerWidth/window.innerHeight, 0.1, 1000)

    light = new THREE.AmbientLight(0x888888)
    scene.add(light)

    light = new THREE.DirectionalLight(0xCCCCCC, 1)
    light.position.set(5,4,5)
    scene.add(light)

    spotLight = new THREE.SpotLight(0xFFFFFF, 1, 1, 45 * deg)
    spotLight.position.set(0,7,0)
    spotLight.shadowCameraNear = 0.01
    spotLight.castShadow = true
    spotLight.shadowDarkness = 0.8
    #spotLight.shadowCameraVisible = true

    scene.add(spotLight)

    groundGeometry = new THREE.PlaneGeometry(8,4,100,100)
    groundMaterial = new THREE.MeshPhongMaterial()
    ground = new THREE.Mesh(groundGeometry, groundMaterial)
    ground.rotation.y = 0
    ground.rotation.x = -90 * deg
    ground.rotation.z = 0
    ground.receiveShadow = true

    scene.add(ground)

    #create Sphere
    sphereMaterial = new THREE.MeshPhongMaterial()
    radius = 0.5
    segments = 128
    rings = 128
    sphereGeometry = new THREE.SphereGeometry(radius, segments, rings)
    #sphereMaterial.map = THREE.ImageUtils.loadTexture('images/death_star.jpg')
    sphereMaterial.map = THREE.ImageUtils.loadTexture('images/earthmap1k.jpg')
    sphereMaterial.bumpMap = THREE.ImageUtils.loadTexture('images/earthbump1k.jpg')
    sphereMaterial.bumpScale = 0.05
    sphereMaterial.specularMap = THREE.ImageUtils.loadTexture('images/earthspec1k.jpg')
    sphereMaterial.specular = new THREE.Color('grey')

    sphere = new THREE.Mesh(sphereGeometry, sphereMaterial)
    sphere.castShadow = true
    sphere.receiveShadow = false

    scene.add(sphere)

    camera.position.set(0,2,4)

    #rotation = @getRotation()

    #RENDER THE SCENE
    #@renderScene(renderer, scene, camera, sphere, rotation)

    Leap.loop (frame) ->

      if frame.pointables.length > 1

        for hand in frame.hands
          rotX = -hand.palmNormal[2] * 2
          rotZ = hand.palmNormal[0] * 2

          radius = hand.sphereRadius / 50

          offsetX = hand.palmPosition[0] / 100
          offsetY = hand.palmPosition[1] / 100
          offsetZ = hand.palmPosition[2] / 100

          sphere.rotation.set(rotX,0,rotZ)
          #sphere.scale.set(radius,radius,radius)
          sphere.position.set(offsetX,offsetY,offsetZ)

      else
        #sphere.rotation.set(0,0,0)
        sphere.rotation.y += 0.01
        posY = sphere.position.y
        if posY > 0.5
          posY -= 0.01
        else
          posY = 0.5
        sphere.position.y = posY

      renderer.render(scene, camera)

    #render = ->
      #requestAnimationFrame(render)

      #cube.rotation.x += 0.01
      #sphere.rotation.y = rotationY




    #render()

  
  
SpecificTheme.current = new SpecificTheme()

$ ->
  SpecificTheme.current.domReady()

window.SpecificTheme = SpecificTheme