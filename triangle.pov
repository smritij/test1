triangle {
<-0.5,-0.5,0>
<0.5,-0.5,0>
<-0.5,0.5,0>
pigment {
color rgb <1, 1, 0>
}
translate <-5, 2, 1>
rotate <0,2,0>
scale <2,1,0.5>
}

camera {
location <-2, 3, -10>
look_at <0, 5, 0>
direction < 1,1,-1>
angle 45
}

light_source {
<10, 10, -10> color rgb <0,0,0>
}
