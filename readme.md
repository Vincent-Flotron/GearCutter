Readme
------


## Requirments
- pip install solidpython2


## A test with animation on OpenSCAD

### 1. Open the file
OpenSCAD and open file `test_openscad\gen_gear_shaper_sim.scad`

### 2. Activate animation
Activate animation on menu **Vue** -> **Animation**

### 3. Settings on the Animation vue
```txt
FPS:    30
Étapes: 2000
```

### 4. Result in image
![alt text](doc_images/image.png)

### 5. Known issues
- The more the time is passing, the more the animation becomes slower
- Parameters orbital_radius, orbit_speed and spin_speed are set by hand instead of beeing parametrized depending on the "sun" cylinder radius, module, etc ...