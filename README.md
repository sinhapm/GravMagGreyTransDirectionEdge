# GravMagGreyTransDirectionEdge

**Scope of Program Field: Gravity, Magnetic & Remote Sensing Dataset**

_**Platform: MATLAB**_

The program calculates the Gray Level Transformed Directional Normalized Standard Deviations (NSTD) for Edge Detection.

It takes the 2D gridded points input (Irap Classic Points format) such as Input File Format (X(Integer) Y(Integer) Z(Float)) - XY in ascending order top to bottom direction of Input data: 1. West to East: Left to Right, 2. South to North: Top to Bottom

Input File can be Regular spaced Rectangular/Square Grid Points or may be Regular spaced Oblique Grid Points, which is padded with nearest outer points to make it Regular spaced Rectangular Grid Points.

>Sample input ASCII file (Regular spaced Rectangular Grid Points), PPT file & output ASCII file are attached for the reference in the folder **./Reference**

------------------------------------------------------------------------------------------
Runtime Input Parameters:

Size of Filtering Window (positive odd numbers only), minimum default =3

Size of Smoothing Window (positive odd numbers only), zero or -ve values apply no smoothing

Gray Level Transformation Levels, positive value only

Multi-Direction Flag = Y/N, Yes/No

------------------------------------------------------------------------------------------

Outputs are followings: 
NSTD (All Direction) = NSTD for all values (360 deg)

Additionally, if multi-Direction flag is Y/Yes

NSTD(East-West) = Filtered NSTD for East West Direction - Edge/Lineament along North South effective Direction

NSTD(North-South) = Filtered NSTD for North South Direction - Edge/Lineament along East West effective Direction

NSTD_NWSE = Filtered NSTD for NW-SE Direction - Edge/Lineament along effective NE-SW Direction

NSTD_NESW = Filtered NSTD for NE-SW Direction - Edge/Lineament along effective NW-SE Direction

------------------------------------------------------------------------------------------

Output file (ASCII) format: 1. Petrel Points with attributes file or 2. Tab delimited Columnar file  

------------------------------------------------------------------------------------------
The usage of the program is limited to its scope and user has to ascertain the program output applicability to its scope of work, accuracy etc.

Contact details: Prashant Sinha [e-mail:sinha.pm@gmail.com]

------------------------------------------------------------------------------------------
