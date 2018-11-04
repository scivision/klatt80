
FC = gfortran

FOPTS = -g -O2 -fimplicit-none -fbounds-check -Wno-unused-label -Wline-truncation

klatt: handsy.for parcoe.for coewav.for setabc.for getamp.for
	$(FC) $^ $(FOPTS) -o $@

clean:
	$(RM) klatt
