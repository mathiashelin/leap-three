renderer = new THREE.WebGLRenderer()
renderer.setSize(window.innerWidth, window.innerHeight)
document.body.appendChild(renderer.domElement)

scene = new THREE.Scene()
camera = new THREE.PerspectiveCamera(75, window.innerWidth/window.innerHeight, 0.1, 1000)

light = new THREE.AmbientLight(0x888888)
scene.add(light)

light = new THREE.DirectionalLight(0xCCCCCC, 1)
light.position.set(5,4,5)
scene.add(light)

sphereMaterial = new THREE.MeshPhongMaterial()
radius = 0.5
segments = 128
rings = 128
sphereGeometry = new THREE.SphereGeometry(radius, segments, rings)
sphereMaterial.map = THREE.ImageUtils.loadTexture('images/earthmap1k.jpg')
sphereMaterial.bumpMap = THREE.ImageUtils.loadTexture('images/earthbump1k.jpg')
sphereMaterial.bumpScale = 0.05
sphereMaterial.specularMap = THREE.ImageUtils.loadTexture('images/earthspec1k.jpg')
sphereMaterial.specular = new THREE.Color('grey')

sphere = new THREE.Mesh(sphereGeometry, sphereMaterial)

scene.add(sphere)

camera.position.set(0,0,2)

render = ->
  requestAnimationFrame(render)

  #cube.rotation.x += 0.01
  #sphere.rotation.y += 0.01

  renderer.render(scene, camera)

render()