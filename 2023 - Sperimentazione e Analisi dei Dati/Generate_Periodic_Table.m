% Define the element data as a cell array
element_data = {
    'H', 'Idrogeno', 1;
    'He', 'Elio', 2;
    'Li', 'Litio', 3;
    'Be', 'Berillio', 4;
    'B', 'Boro', 5;
    'C', 'Carbonio', 6;
    'N', 'Azoto', 7;
    'O', 'Ossigeno', 8;
    'F', 'Fluoro', 9;
    'Ne', 'Neon', 10;
    'Na', 'Sodio', 11;
    'Mg', 'Magnesio', 12;
    'Al', 'Alluminio', 13;
    'Si', 'Silicio', 14;
    'P', 'Fosforo', 15;
    'S', 'Zolfo', 16;
    'Cl', 'Cloro', 17;
    'Ar' , 'Argon', 18;
    'K', 'Potassio', 19;
    'Ca', 'Calcio', 20;
    'Sc', 'Scandio', 21;
    'Ti', 'Titanio', 22;
    'V', 'Vanadio', 23;
    'Cr', 'Cromo', 24;
    'Mn', 'Manganese', 25;
    'Fe', 'Ferro', 26;
    'Co', 'Cobalto', 27;
    'Ni', 'Nichel', 28;
    'Cu', 'Rame', 29;
    'Zn', 'Zinco', 30;
    'Ga', 'Gallio', 31;
    'Ge', 'Germanio', 32;
    'As', 'Arsenico', 33;
    'Se', 'Selenio', 34;
    'Br', 'Bromo', 35;
    'Kr', 'Kripton', 36;
    'Rb', 'Rubidio', 37;
    'Sr', 'Stronzio', 38;
    'Y', 'Ittrio', 39;
    'Zr', 'Zirconio', 40;
    'Nb', 'Niobio', 41;
    'Mo', 'Molibdeno', 42;
    'Tc', 'Tecnezio', 43;
    'Ru', 'Rutenio', 44;
    'Rh', 'Rodio', 45;
    'Pd', 'Palladio', 46;
    'Ag', 'Argento', 47;
    'Cd', 'Cadmio', 48;
    'In', 'Indio', 49;
    'Sn', 'Stagno', 50;
    'Sb', 'Antimonio', 51;
    'Te', 'Tellurio', 52;
    'I', 'Iodio', 53;
    'Xe', 'Xeno', 54;
    'Cs', 'Cesio', 55;
    'Ba', 'Bario', 56;
    'La', 'Lantanio', 57;
    'Ce', 'Cerio', 58;
    'Pr', 'Praseodimio', 59;
    'Nd', 'Neodimio', 60;
    'Pm', 'Promezio', 61;
    'Sm', 'Samario', 62;
    'Eu', 'Europio', 63;
    'Gd', 'Gadolinio', 64;
    'Tb', 'Terbio', 65;
    'Dy', 'Disprosio', 66;
    'Ho', 'Olmio', 67;
    'Er', 'Erbio', 68;
    'Tm', 'Tulio', 69;
    'Yb', 'Itterbio', 70;
    'Lu', 'Lutezio', 71;
    'Hf', 'Afnio', 72;
    'Ta', 'Tantalio', 73;
    'W', 'Tungsteno', 74;
    'Re', 'Renio', 75;
    'Os', 'Osmio', 76;
    'Ir', 'Iridio', 77;
    'Pt', 'Platino', 78;
    'Au', 'Oro', 79;
    'Hg', 'Mercurio', 80;
    'Tl', 'Tallio', 81;
    'Pb', 'Piombo', 82;
    'Bi', 'Bismuto', 83;
    'Po', 'Polonio', 84;
    'At', 'Astato', 85;
    'Rn', 'Radon', 86;
    'Fr', 'Francio', 87;
    'Ra', 'Radio', 88;
    'Ac', 'Attinio', 89;
    'Th', 'Torio', 90;
    'Pa', 'Protoattinio', 91;
    'U', 'Uranio', 92;
    'Np', 'Nettunio', 93;
    'Pu', 'Plutonio', 94;
    'Am', 'Americio', 95;
    'Cm', 'Curio', 96;
    'Bk', 'Berkelio', 97;
    'Cf', 'Californio', 98;
    'Es', 'Einsteinio', 99;
    'Fm', 'Fermio', 100;
    'Md', 'Mendelevio', 101;
    'No', 'Nobelio', 102;
    'Lr', 'Laurenzio', 103;
    'Rf', 'Rutherfordio', 104;
    'Db', 'Dubnio', 105;
    'Sg', 'Seaborgio', 106;
    'Bh', 'Bohrio', 107;
    'Hs', 'Hassio', 108;
    'Mt', 'Meitnerio', 109;
    'Ds', 'Darmstadtio', 110;
    'Rg', 'Roentgenio', 111;
    'Cn', 'Copernicio', 112;
    'Nh', 'Nihonio', 113;
    'Fl', 'Flerovio', 114;
    'Mc', 'Moscovio', 115;
    'Lv', 'Livermorio', 116;
    'Ts', 'Tennesso', 117;
    'Og', 'Oganesson', 118;
    };

% Convert the cell array to a structure array
Elements = struct('symbol', element_data(:,1), 'name', element_data(:,2), 'atomic_number', element_data(:,3));

% Save the structure array as a .mat file
save('Elements.mat', 'Elements');