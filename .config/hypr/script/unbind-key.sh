#/bin/bash

comm -23 <(echo -e "A\nB\nC\nD\nE\nF\nG\nH\nI\nJ\nK\nL\nM\nN\nO\nP\nQ\nR\nS\nT\nU\nV\nW\nX\nY\nZ\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0\nRETURN\nESCAPE\nBACKSPACE\nTAB\nSPACE" | awk '{print "SUPER + " $0 "\nSUPER + SHIFT + " $0}' | sort -u) <(hyprctl binds | awk '
/bind/ {
    getline; mod=$2;
    getline; getline; key=$2;
    shift_used = (mod == 65 || mod == 69 || mod == 73);
    if (mod == 64 || mod == 65 || mod == 68 || mod == 69 || mod == 73) {
        if (shift_used) {
            print "SUPER + SHIFT + " key;
        } else {
            print "SUPER + " key;
        }
    }
}' | sort -u)
