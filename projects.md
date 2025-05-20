---
layout: default
title: Projects
---

# current work

## [cake](https://github.com/buggy213/cake)
personal project to learn some compiler theory. targets C language and (rv64? x86? arm?) backend. 

currently still very much in progress, and rather disorganized. my goal this summer is to have a working compiler-assembler-linker stack with some basic optimization passes implemented. i'm hoping to take cs264 sometime soon and use that knowledge as well

## [opencl-raytracing](https://github.com/buggy213/opencl-raytracing)
a bit poorly named, this is a big raytracing i hope to work on some over the summer also. current goals are to focus on vulkan / dxr / optix / other hw-accelerated raytracing and learn more about these apis. 

i'd also like to explore:
- radiosity-based methods (lumen)
- volumetric path tracing
- spectral path tracing
- polarization aware path tracing
- physical-optics rendering
- good caustics (photon mapping, specular cuts, etc.)
- restir, restir gi, other "restir methods"
- neural rendering (denoising, radiance caching, etc.) 

## radiance
research project at berkeley's slice lab. i plan to work on building out a raytracing acceleration unit (think nvidia's rt cores, intel's rtu)

# prior work

## bubble simulator
based on the paper of Ishida et al. (2017), code simulates bubble surface dynamics using a hyperbolic geometric flow. mathematically, every point on the surface is accelerated proportional to the mean curvature at that point. intuitively, bubbles minimize their surface area, so protruding or sunken in parts get "flattened out". 

combined with thin-film appearance model of Belcour and Barla (2017) within rgb pathtracing framework (hw3 from cs184).

spring 2024 cs184 showcase honorable mention

todo: add image

## [python mce](https://github.com/buggy213/ast-experiments)
metacircular evaluator written in python. extremely simple implementation due to the highly dynamic nature of python, as well as built-in libraries for ast manipulation.

## [distpcsr](https://www2.eecs.berkeley.edu/Pubs/TechRpts/2023/EECS-2023-235.pdf)
cs267 final project. implements a pcsr data structure in a distributed setting.

theory: supporting highly dynamic graphs with large numbers of queries and global graph algorithms running on it is difficult, especially when the data is sharded across many different machines. distpcsr addresses this with a pcsr data structure (essentially an array with holes in it) on each local "rank", and a routing layer for inserts / queries. it also supports global redistributes to load balance as well as graph-wide algorithms like bfs, pagerank, etc.

implemented in upc++ programming language, tested on perlmutter supercomputer.