#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vsimple_alu.h"
//#include "Valu___024unit.h"

#define MAX_SIM_TIME 20
vluint64_t sim_time = 0;

int main(int argc, char** argv, char** env) {
    Vsimple_alu *dut = new Vsimple_alu;
    int clk_count;
    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveform.vcd");
    
    dut->rst_n = 0;
    for (clk_count = 0; clk_count <20; ++clk_count) {
	    dut->clk ^= 1;
        dut->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }
    dut->rst_n = 1;
    for (clk_count = 0; clk_count <2; ++clk_count) {
	    dut->clk ^= 1;
        dut->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }
    dut->avs_address = 0;
    dut->avs_write_data = 42;
    dut->avs_write = 1;
    dut->avs_read=0;

    for (clk_count = 0; clk_count <20; ++clk_count) {
	    dut->clk ^= 1;
        dut->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }
    
    dut->avs_address = 1;
    dut->avs_write_data = 20;
    dut->avs_write = 1;
    dut->avs_read=0;

    for (clk_count = 0; clk_count <20; ++clk_count) {
	    dut->clk ^= 1;
        dut->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }
    
    dut->avs_address = 2;
    dut->avs_write_data =2;
    dut->avs_write = 1;
    dut->avs_read=0;

    for (clk_count = 0; clk_count <20; ++clk_count) {
	    dut->clk ^= 1;
        dut->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }
    
    dut->avs_address = 3;
    dut->avs_write_data =2;
    dut->avs_write = 0;
    dut->avs_read=1;

    for (clk_count = 0; clk_count <20; ++clk_count) {
	    dut->clk ^= 1;
        dut->eval();
        m_trace->dump(sim_time);
        sim_time++;
    }

  //  while (sim_time < MAX_SIM_TIME) {
  //      dut->clk ^= 1;
  //      dut->eval();
  //      m_trace->dump(sim_time);
  //      sim_time++;
  //  }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}

