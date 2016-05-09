# HeroesClient

The goal is to be able to play HoMM III comfortable from the iPhone. 
Current idea is to split whole screen in parts: like when your hero walking outside, there can be from 3-5 screen parts: 
  * map, where you hero walks
  * heroes selection
  * castles selection
  * minimap
  * actions menu
  
Currenly tested with RealVNC and TightVNC servers. 
The latter seems to handle faster (because the former falls back on RAW encoding, which is not efficient), so I would recomment using TightVNC to test.
  
# TODO

 - [ ] automatic screen type detection
 - [ ] 16-bit pixelformat support for VNC-library
 - [ ] support for active/invasive screen parts (hire units in castle, open magic book during battle, etc) which requires interaction, not just screen part draw
 - [ ] some mockups in README for easier understanding
 
 
 # License
 MIT 
 
 # Contibutions are welcome!
 
