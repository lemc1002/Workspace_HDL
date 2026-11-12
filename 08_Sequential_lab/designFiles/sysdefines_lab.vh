`ifndef SYSDEFINES_LAB_VH
`define SYSDEFINES_LAB_VH

`define DFF_E(iClk, inRst, iEn, iD, oQ) \
always @(negedge iClk, negedge inRst) begin \
    if (!inRst) \
        oQ <= 0; \
    else if (iEn) \
        oQ <= iD; \
end

`endif
