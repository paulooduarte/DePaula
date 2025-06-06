// Exemplo simples de cena 3D com movimentação de câmera em primeira pessoa.

let scene, camera, renderer;
let moveForward = false,
    moveBackward = false,
    moveLeft = false,
    moveRight = false;

let velocity = new THREE.Vector3();
let direction = new THREE.Vector3();

const pointerLockChange = () => {
  if (document.pointerLockElement === document.body) {
    document.addEventListener('mousemove', onMouseMove, false);
  } else {
    document.removeEventListener('mousemove', onMouseMove, false);
  }
};

const onMouseMove = (event) => {
  camera.rotation.y -= event.movementX * 0.002;
  camera.rotation.x -= event.movementY * 0.002;
  camera.rotation.x = Math.max(-Math.PI / 2, Math.min(Math.PI / 2, camera.rotation.x));
};

document.addEventListener('pointerlockchange', pointerLockChange, false);

document.addEventListener('keydown', (event) => {
  switch (event.code) {
    case 'ArrowUp':
    case 'KeyW': moveForward = true; break;
    case 'ArrowLeft':
    case 'KeyA': moveLeft = true; break;
    case 'ArrowDown':
    case 'KeyS': moveBackward = true; break;
    case 'ArrowRight':
    case 'KeyD': moveRight = true; break;
  }
});

document.addEventListener('keyup', (event) => {
  switch (event.code) {
    case 'ArrowUp':
    case 'KeyW': moveForward = false; break;
    case 'ArrowLeft':
    case 'KeyA': moveLeft = false; break;
    case 'ArrowDown':
    case 'KeyS': moveBackward = false; break;
    case 'ArrowRight':
    case 'KeyD': moveRight = false; break;
  }
});

function init() {
  scene = new THREE.Scene();
  camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
  renderer = new THREE.WebGLRenderer({ antialias: true });
  renderer.setSize(window.innerWidth, window.innerHeight);
  document.body.appendChild(renderer.domElement);

  const light = new THREE.DirectionalLight(0xffffff, 1);
  light.position.set(5, 10, 7.5);
  scene.add(light);

  const geometry = new THREE.BoxGeometry(1, 1, 1);
  const material = new THREE.MeshStandardMaterial({ color: 0x0077ff });
  const cube = new THREE.Mesh(geometry, material);
  scene.add(cube);

  camera.position.set(0, 1.6, 5);

  document.body.addEventListener('click', () => {
    document.body.requestPointerLock();
  });

  animate();
}

function animate() {
  requestAnimationFrame(animate);

  const delta = 0.1;
  velocity.set(0, 0, 0);

  if (moveForward) velocity.z -= delta;
  if (moveBackward) velocity.z += delta;
  if (moveLeft) velocity.x -= delta;
  if (moveRight) velocity.x += delta;

  direction.copy(velocity).applyEuler(camera.rotation);
  camera.position.add(direction);

  renderer.render(scene, camera);
}

init();
