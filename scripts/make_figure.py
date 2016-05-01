#make_figure v.3.0
#Copyleft Martin Christen, 2010

from pymol import cmd
def make_figure(output='', mode='',size=900,opaque='transparent'):

	"""

AUTHOR

	Martin Christen


DESCRIPTION

	"make_figure" creates publication-quality figures of the current scene.
	It understands several predefined "modes" and sizes.


USAGE

	make_figure filename [, mode] [, size (default=900 pixels)] [,opaque]


ARGUMENTS

	mode = string: type of desired figure (single, fb, sides, stereo or -nothing-)
	size = integer: size of the figure in pixels OR # panels (if <= 12)
	opaque = specify an opaque background.
	         By default, the script makes the background transparent.
EXAMPLES

	make_figure output
	make_figure output, single, 975, opaque
	make_figure output, fb, 2
	make_figure output, sides,4
	make_figure output, stereo


NOTES

	"single" mode makes a single 300 dpi figure
	
	"fb" mode makes TWO 300 dpi figure
	("front" and "back", rotating by 180 degrees about y)
	
	"sides" mode makes FOUR 300 dpi figures
	("front" "left" "right" and back, rotating by 90 degrees clockwise about y)
	
	"stereo" generates two 300 dpi, 750 px figures
	("L" and "R", to be combined as a stereo image)
	If you specify the stereo mode, the size argument is IGNORED.
		
	If no mode argument is given, the script generates quick figures
	for general	use: TWO figures (front and back) at 300 x 300 px, 72 dpi.
	
	Size is interpreted as pixels, except if the number is ridiculously small
	(<=12),	in which case the script as "number of panels" to make.

	Edit the script manually to define corresponding values.
	
	"""

	#define sizes here (in pixels)
	panel1 = 1800
	panel2 = 1350
	panel3 = 900
	panel4 = 900
	panel5 = 750
	panel6 = 750
	panel7 = 675
	panel8 = 675
	panel9 = 600
	panel10 = 585
	panel11 = 585
	panel12 = 585
	
	#verify size is an integer number and convert to pixels
	size = int(size)
	if size > 12:
		pixels = size
	
	elif size == 1:
		pixels = panel1
	
	elif size == 2:
		pixels = panel2
	
	elif size == 3:
		pixels = panel3
	
	elif size == 4:
		pixels = panel4
	
	elif size == 5:
		pixels = panel5
	
	elif size == 6:
		pixels = panel6
	
	elif size == 7:
		pixels = panel7
	
	elif size == 8:
		pixels = panel8
	
	elif size == 9:
		pixels = panel9
	
	elif size == 10:
		pixels = panel10
	
	elif size == 11:
		pixels = panel11
	
	elif size == 3:
		pixels = panel12

	#change background
	cmd.unset('opaque_background')
	if opaque == 'opaque':
		cmd.set('opaque_background')
	
	#apply mode
	if output == '':
		print 'no output filename defined\n'
		print 'try: \'make_figure filename\''
		return -1
		# abort if no output file name given

	if mode =='':
		cmd.set('surface_quality',1)
		cmd.set('opaque_background')
		cmd.png(output+"_back_quick",300,300,dpi=72)
		cmd.turn('y',180)
		cmd.png(output+"_front_quick",300,300,dpi=72)
		cmd.turn('y',180)
		cmd.set('surface_quality',0)
		# make front and back figures for quick mode

	elif mode == 'single':
		cmd.set('surface_quality',1)
		cmd.set('ray_shadow',0)
		cmd.ray(pixels, pixels)
		cmd.png(output, dpi=300)
		cmd.set('surface_quality',0)
		# make a figure for single mode
		
	elif mode == 'fb':
		cmd.set('surface_quality',1)
		cmd.set('ray_shadow',0)
		cmd.ray(pixels, pixels)
		cmd.png(output+"_front", dpi=300)
		cmd.turn('y',180)
		cmd.ray(pixels, pixels)
		cmd.png(output+"_back", dpi=300)
		cmd.turn('y',180)
		cmd.set('surface_quality',0)
		# make front and back figures for single mode

	elif mode == 'sides':
		cmd.set('surface_quality',1)
		cmd.set('ray_shadow',0)
		cmd.ray(pixels, pixels)
		cmd.png(output+"_1", dpi=300)
		cmd.turn('y',90)
		cmd.ray(pixels, pixels)
		cmd.png(output+"_2", dpi=300)
		cmd.turn('y',90)
		cmd.ray(pixels, pixels)
		cmd.png(output+"_3", dpi=300)
		cmd.turn('y',90)
		cmd.ray(pixels, pixels)
		cmd.png(output+"_4", dpi=300)
		cmd.turn('y',90)
		cmd.set('surface_quality',0)
		# make front and back figures for single mode
		
	elif mode == 'stereo':
		cmd.set('surface_quality',1)
		cmd.set('ray_shadow',0)
		cmd.ray(750, 750, angle=-3)
		cmd.png(output+"_R", dpi=300)
		cmd.ray(750, 750, angle=3)
		cmd.png(output+"_L", dpi=300)
		# make stereo figure (for more control use stereo_ray)
		
cmd.extend('make_figure',make_figure)
