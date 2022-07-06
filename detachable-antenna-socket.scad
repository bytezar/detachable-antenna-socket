include<BOSL/constants.scad>
use<BOSL/transforms.scad>
use<BOSL/shapes.scad>

//epsilon
eps=0.001;

//connector rp-sma
con_d=6.8; //hole diameter
con_nt_d=9.8; //nut hole diameter
con_nt_th=1.6; //nut hole thickness
con_fn=64; //hole accuracy (fn)

//main cylinder
cyl_d=12.8; //inner diameter
cyl_bs=1.6; //base thickness
cyl_wl=1.6; //wall thickness
cyl_h=4.6; //inner height
cyl_fn=128; //hole accuracy (fn)

//bolt m2.5 holder
bt25_hld_h=7; //holder height
bt25_hld_w=8.4; //holder weigth
bt25_hld_l=5; //holder length
bt25_hld_fn=64; //holder accuracy (fn)

bt25_d=3; //bolt hole diameter
bt25_fn=32; //bolt hole accuracy (fn)

bt25_nt_d=6.2; //nut hole diameter
bt25_nt_h=2.4; //nut hole height

bt25_hd_d=5.2; //bolt head diameter
bt25_hd_h1=1.8; //bolt cone head hole height
bt25_hd_h2=0.6; //bolt cylinder head hole height
bt25_hd_fn=32; //hole accuracy (fn)

// Computed common values:
hh1=cyl_h+cyl_bs;
hh2=bt25_hld_h+cyl_bs;
dd=cyl_d+2*cyl_wl;


union()
{
	difference()
	{
		union()
		{
			main_cylinder();
			bolt_m25_nut_holder();
		}
		
		cylinder_holes();
		bolt_m25_holes();
	}
	
	connector_nut_holder();
}

module main_cylinder()
{
	cylinder(d=dd,h=hh1,$fn=cyl_fn);
}

module cylinder_holes()
{
	up(cyl_bs)
	cylinder(d=cyl_d,h=hh2,$fn=cyl_fn);
	
	down(1)
	cylinder(d=con_d,h=cyl_bs+2,$fn=con_fn);
}

module bolt_m25_nut_holder()
{
	cuboid([bt25_hld_w,dd/2+bt25_hld_l,hh2-bt25_hld_w/2],
		align=V_UP+V_BACK);
	
	up(hh2-bt25_hld_w/2)
	ycyl(d=bt25_hld_w,h=dd/2+bt25_hld_l,$fn=bt25_hld_fn,
		center=false);
}

module bolt_m25_holes()
{
	_w=bt25_nt_d*sqrt(3)/2;
	_h=bt25_hld_h/2+cyl_bs;
	_y=dd/2+bt25_hld_l;

	// bolt nut holes:
	move([0,dd/2,_h])
	yrot(30)
	ycyl(d=bt25_nt_d,h=bt25_nt_h,$fn=6,
		center=false);
	
	move([0,dd/2,-1])
	cuboid([_w,bt25_nt_h,_h+1],
		align=V_UP+V_BACK);
	
	// bolt hole:
	move([0,0,_h])
	ycyl(d=bt25_d,h=_y+1,$fn=bt25_fn,
		center=false);
	
	// bolt head holes:
	move([0,_y-bt25_hd_h1-bt25_hd_h2,_h])
	ycyl(d1=bt25_d,d2=bt25_hd_d,h=bt25_hd_h1+eps,
		$fn=bt25_hd_fn,center=false);
	
	move([0,_y-bt25_hd_h2,_h])
	ycyl(d=bt25_hd_d,h=bt25_hd_h2+1,
		$fn=bt25_hd_fn,center=false);
}

module connector_nut_holder()
{
	up(cyl_bs)
	difference()
	{
		cylinder(d=cyl_d,h=con_nt_th,$fn=cyl_fn);
		
		down(1)
		cylinder(d=con_nt_d,h=con_nt_th+2,$fn=6);
		
		down(1)
		cuboid([cyl_d+2,cyl_d/2+1,con_nt_th+2],
		  align=V_UP+V_BACK);
	}
}
