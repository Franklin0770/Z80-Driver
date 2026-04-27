SampleIndexText:	dc.l vdpCoordinates(0,0)
	dc.b 15-1,"Sample Index: $"
z80SamplesText:		dc.l vdpCoordinates(0,1)
	dc.b 24-1,"Z80 Samples Per-frame: $"

	align 2

LastSampleText:		dc.l vdpCoordinates(0,2)
	dc.b 18-1,"Last 68k Sample: $"

	align 2

FrameCounterText:	dc.l vdpCoordinates(0,3)
	dc.b 15-1,"Frame Number: $"

	align 2

ButtonMessage1:		dc.l vdpCoordinates(0,7)
	dc.b 22-1,"Press B to play a note"

	align 2

ButtonMessage2:		dc.l vdpCoordinates(0,8)
	dc.b 28-1,"Press C to restart the music"