# FPGA-频率计 
### 2022.3 满分
在1Hz至300MHz范围内，误差小于0.01%

#### trick
* measure.v line33:
`
if(gate)cntsig<=cntsig+1;
`
先前用的gateout，由于非阻塞赋值，当gateout被置零后，if中的gateout仍是先前的1值，直到下个周期才会变0，使cntsig多计一个周期

* measure.v line42:

`
  cnt<=(cnt<100000000)?(cnt+1):0;
  gate<=(cnt>49000000)?0:1;
`
控制了预置门gate的低电平时间为51000000*20ns=1.02s >1s 大于最低频信号的周期

否则，若gate低电平时间不够长，则会在测低频信号时导致：gate置低后，gateout仍应保持高电平直至测完此次sigin，而在gateout继续保持的时间里，下一个周期的gate高电平又来了，导致gateout仍保持高电平未被置低，使得采样时间大大延长
