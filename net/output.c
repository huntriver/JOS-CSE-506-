#include "ns.h"

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
	binaryname = "ns_output";

	for (;;)
		if (ipc_recv(0,&nsipcbuf,0)==NSREQ_OUTPUT)
			while (sys_transmit_packet(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len)<0)
				sys_yield();
}

