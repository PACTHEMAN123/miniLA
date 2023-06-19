VSRC = $(wildcard vsrc/* mySoC/*) 
CSRC = $(wildcard golden_model/*.c) $(wildcard golden_model/stage/*.c) $(wildcard csrc/*.c csrc/*.cpp)
SIM_OPTS = --trace -Wno-lint -Wno-style
TEST = addi
TESTFILE = meminit.bin

build: $(VSRC) $(CSRC)
	@verilator -cc --exe --build $(VSRC) --top-module miniLA_SoC $(CSRC) $(SIM_OPTS) +define+PATH=$(TESTFILE) -CFLAGS -DPATH=$(TESTFILE) -ImySoC -CFLAGS -I$(PWD)/gloden_model/include
	@mkdir -p waveform
run: build
	@ln -sf bin/$(TEST).bin $(TESTFILE)
	@./obj_dir/VminiLA_SoC $(TEST)
run_for_python:  # should run "make all" first, for python-based test
	@ln -sf bin/$(TEST).bin $(TESTFILE)
	@./obj_dir/VminiLA_SoC $(TEST)
	@rm -rf $(TESTFILE)
$(TESTFILE):
	ln -sf bin/$(TEST).bin $(TESTFILE)
clean:
	rm -rf obj_dir waveform $(TESTFILE)

.PHONY: run debug clean
