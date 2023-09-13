# ElMapMatlab
 Implementation of Elastic Maps for Trajectory Generation in MATLAB
 
 Uses a general version of the convex optimization of elastic maps as found here: https://github.com/brenhertel/LfD-Perturbations
 
 To generate an elastic map reproduction, call the `ElasticMap` function, passing the data for the map to be modeled on, the data weights, stretching and beening constants, initial guess of the map, and any constraints. For help, see the example in https://github.com/brenhertel/ElMapMatlab/blob/main/elmap_test.m.

If you have any questions, please contact Brendan Hertel (brendan_hertel@student.uml.edu).

If you use the code present in this repository, please cite the following papers:
```
@inproceedings{hertel2022ElMap,
  title={Robot Learning from Demonstration Using Elastic Maps},
  author={Hertel, Brendan and Pelland, Matthew and S. Reza Ahmadzadeh},
  booktitle={IEEE/RSJ International Conference on Intelligent Robots and Systems (IROS)},
  year={2022},
  organization={IEEE}
}
```
and
```
@inproceedings{hertel2023confidence,
  title={Confidence-Based Skill Reproduction Through Perturbation Analysis},
  author={Hertel, Brendan and S. Reza Ahmadzadeh},
  booktitle={20th International Conference on Ubiquitous Robots (UR)},
  year={2023},
  organization={IEEE}
}
```
