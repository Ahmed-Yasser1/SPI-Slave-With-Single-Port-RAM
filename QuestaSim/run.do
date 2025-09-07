vlib work
vlog SPI_slave.v SPI_RAM.v SPI_wrapper.v SPI_tb.v
vsim -voptargs=+acc work.SPI_tb
add wave *
add wave -position insertpoint  \
sim:/SPI_tb/dut/tx_valid \
sim:/SPI_tb/dut/tx_data \
sim:/SPI_tb/dut/rx_valid \
sim:/SPI_tb/dut/rx_data
add wave -position insertpoint  \
sim:/SPI_tb/dut/slave/cs
add wave -position insertpoint  \
sim:/SPI_tb/dut/slave/ns
add wave -position insertpoint  \
sim:/SPI_tb/dut/slave/count_add
add wave -position insertpoint  \
sim:/SPI_tb/dut/slave/count_data
add wave -position insertpoint  \
sim:/SPI_tb/dut/slave/read_mode
add wave -position insertpoint  \
sim:/SPI_tb/dut/ram/add
add wave -position insertpoint  \
sim:/SPI_tb/dut/ram/mem
run -all
#quit -sim