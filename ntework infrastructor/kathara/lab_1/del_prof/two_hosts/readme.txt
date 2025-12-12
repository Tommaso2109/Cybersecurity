This is the most basic Kathara lab.
Here you have only two hosts with a single network interface connected to a single collision domain.
The ip addresses of the nodes are set in the *.startup files and they are set as soon as they boot up.
You can test the connectivity by pinging from one host to the other.

The file 'shared/cap.pcap' is a capture of all the packets exchanged between the two hosts when pc1 sends 3 ping packets to pc2
