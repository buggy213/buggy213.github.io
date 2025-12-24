---
layout: default
title: Room Acoustics
---

# Overview
This was my final project for Music 159 at Berkeley (Computer Programming for Music Applications). The envisioned application is to take a description of the geometry and materials which make up some room, as well as a set of source and listener positions, then simulate what the room "sounds like". As an example, imagine a large, empty hall with concrete walls; this would lead to a very echo-y auditory environment. You can use this in order to determine what a concert hall sounds like before construction, or to create a more immersive experiences for video games / virtual reality. 

Commercially available software packages (COMSOL Multiphysics, ODEON, Treble SDK) perform these simulations as well, at varying levels of cost and fidelity. 

The core of the system is a finite-difference acoustic solver which solves the acoustic wave equation. 
Specifically, it solves the acoustic wave equation `$\nabla^2 p = \frac{1}{c^2}\frac{\partial^2 p}{\partial t^2}$` through a 2nd-order finite difference discretization of the Laplacian operator and a Leapfrog integration scheme. In practice, this means applying a stencil to the pressure grid, then updating pressures according to the above equation at every timestep. The discretization coarseness (both spatially and temporally) is controlled by max frequency of simulation as well as user-specified CFL number. 

To truncate the computational grid, I used the approach of the original ARD paper and implemented a PML (perfectly matched layer) on the edge of the computational cell. The main idea of the PML transformation is that evaluating the wave equation along a complex contour can transform propagating waves into decaying ones. My background is more in optics -- this is analogous to materials in optics with nonzero $\kappa$ (absorption coefficient), usually conductors. However, there has to be a lot of care to ensure that the acoustic impedance (analogous to complex-valued index of refraction) remains the same across the air-PML boundary so no reflections occur. I used Steven Johnson's 18.336 course notes as a reference and adapted it to the case of the acoustic wave equation. The update rules (for a PML which absorbs waves incident from the -x axis; other cases are similar) are listed below.

- `$\frac{\partial p}{\partial t} = K \nabla \cdot \vec{v} - \sigma_x p + \psi$`

- `$\frac{\partial v_x}{\partial t} = \frac{1}{\rho_0} \frac{\partial p}{\partial x} - \sigma_x v_x$`

- `$\frac{\partial v_y}{\partial t} = \frac{1}{\rho_0} \frac{\partial p}{\partial y}$`

- `$\frac{\partial \psi}{\partial t} = K_0 \sigma_x \frac{\partial v_y}{\partial y}$`

Where `$K_0 = 144120 \text{ N/m}^2$` is the bulk modulus of compressibility for air and `$\rho_0 = 1.225 \text{ kg/m}^3$` is the density of air, both at standard conditions. 
`$\psi$` is discretized on the same grid as `$p$`, while `$v_x$` and `$v_y$` are discretized along staggered grids (2D analogue of standard Yee cells), and the first order spatial derivatives are discretized using central finite-differences as well. Leapfrog integration is also used to do time-updates, with `$v_x$` and `$v_y$` being stepped together in an alternating sequence with $\psi$ and $p$ together. Also, a first-order hold approximation is applied, which leads to an integrating factor of `$e^{-\sigma_x \Delta t}$` for `$v_x$`, `$p$`, and `$\psi$` in their update rules. 

There is a lot of material online about PMLs for electrodynamics, but very little in how it would be used for acoustics (and it is left unspecified in the original paper also, beyond a brief mention). Therefore, I'm not entirely sure how good the PML implementation is. However, based on some rather non-rigorous experiments, I think it provides about -30 to -40dB of attenuation on reflected waves, which should be relatively imperceptible. 

There is a small numerical instability in the Leapfrog integration scheme involving the DC pressure mode, which can grow unboundedly. I think the correct way to deal with this is to subtract mean pressure at every timestep, though I didn't do this since I haven't had time to reason about how it interacts with the PML boundary conditions. To deal with this, I just used a source with zero DC component; the excitation of the DC mode due to numerical dispersion is basically negligible in timeframe needed to get an impulse response.

In order to actually extract an impulse response, I push some source (I used Ricker Wavelet or "Mexican-hat" for experiments, band-limited Gaussian pulse had a DC component) and measure the pressure at some point (the "microphone"). Then, I deconvolve the measured pressure with the source using the Wiener Deconvolution technique described in class in order to get an impulse response. The results are a little bit questionable, but it kinda works.

I have also a working implementation of the spectral DCT-based solver in the Jupyter notebook, but didn't implement it in the final version due to time constraints. The idea is that acoustic waves with fully reflective boundary conditions can only propagate with an integer number of half-wavelengths within a rectangular cavity (this is fully analogous to how electromagnetic waves are restricted to these same modes in rectangular cavities). These modes can be efficiently computed using the DCT and inverse DCT, and the "spectral" update on these modes is almost trivial. The original Adaptive Room Decomposition paper goes into more detail.

A lot of the final implementation was coded with the help of a coding agent, though the original notebook is all mine. 

# Results
TODO: add animation / plot outputs

# Future Work
In addition to verifying the implementation against a benchmark scene, or a real acoustic environment, I think the most interesting future directions are hybridizing this system with a geometric-acoustics based approach and more accurately modeling the frequency response of the computational boundary. 

I plan to resume working on this at some point in the future, as the geometric-acoustics solver seems like it might be an interesting application of hardware ray-tracing.

# References
- [github](https://github.com/buggy213/music159)
- [adaptive room decomposition](https://gamma.cs.unc.edu/SOUND09/PAPERS/nikunj_TVCG.pdf)
- [perfectly matched layer](https://math.mit.edu/~stevenj/18.369/spring09/pml.pdf)
TODO: add initial project proposal / final project. the video is probably too big to host directly sadly
