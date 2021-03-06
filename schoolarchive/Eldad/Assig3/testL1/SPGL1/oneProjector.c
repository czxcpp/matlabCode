/* oneProjector.c
   $Id: oneProjector.c 272 2007-07-19 05:40:29Z mpf $

   ----------------------------------------------------------------------
   This file is part of SPGL1 (Spectral Projected Gradient for L1).

   Copyright (C) 2007 Ewout van den Berg and Michael P. Friedlander,
   Department of Computer Science, University of British Columbia, Canada.
   All rights reserved. E-mail: <{ewout78,mpf}@cs.ubc.ca>.

   SPGL1 is free software; you can redistribute it and/or modify it
   under the terms of the GNU Lesser General Public License as
   published by the Free Software Foundation; either version 2.1 of the
   License, or (at your option) any later version.

   SPGL1 is distributed in the hope that it will be useful, but WITHOUT
   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
   or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General
   Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with SPGL1; if not, write to the Free Software
   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301
   USA
   ----------------------------------------------------------------------
*/
#include "oneProjector_core.h"
#include "mex.h"


/* ----------------------------------------------------------------------- */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
/* ----------------------------------------------------------------------- */
{  const mxArray *vectorD;
   const mxArray *lambda;
   mxArray       *vectorB;
   mxArray       *vectorX;
   mxArray       *vectorDcopy;
   int           *ptr;
   int            i, n;
   unsigned int   dims[2];
   

   /* Free memory and exit if no parameters are given */
   if (nrhs == 0)
   {  if (nlhs != 0) { mexErrMsgTxt("No output arguments expected."); }
      return ;
   }

   /* Check for proper number of arguments */
   if ((nrhs != 2) && (nrhs != 3)) { mexErrMsgTxt("Two or three input arguments required."); }
   if ((nlhs  > 2)               ) { mexErrMsgTxt("Too many output arguments.");             }

    /* Extract the arguments */
    if (nrhs == 2)
    {  vectorB = (mxArray *)prhs[0];
       vectorD = NULL;
       lambda  = prhs[1];
    }
    else
    {  vectorB = (mxArray *)prhs[0];
       vectorD = prhs[1];
       lambda  = prhs[2];
       if (mxIsEmpty(vectorD)) vectorD = NULL;
    }

    /* Verify validity of input argument 'b' */
    if (mxIsEmpty(vectorB))
    {   /* If vector B is empty, simply return an empty projection */
        plhs[0] = mxCreateNumericMatrix(0, 0, mxDOUBLE_CLASS, mxREAL);
        mexWarnMsgTxt("Returning empty projection.");
        return ;       
    }
    if (!mxIsDouble(vectorB)  || ((mxGetM(vectorB) > 1) &&
       (mxGetN(vectorB) > 1)) || (mxGetNumberOfDimensions(vectorB) != 2))
    {   mexErrMsgTxt("Parameter 'b' has to be a double vector.");
    }

    /* Verify validity of input argument 'd' */
    if (vectorD != NULL)
    {  if (!mxIsDouble(vectorD)  || ((mxGetM(vectorD) > 1) &&
          (mxGetN(vectorD) > 1)) || (mxGetNumberOfDimensions(vectorD) != 2))
       {   mexErrMsgTxt("Parameter 'd' has to be a double vector.");
       }
       if (mxGetNumberOfElements(vectorD) != mxGetNumberOfElements(vectorB))
       {   mexErrMsgTxt("Parameters 'b' and 'd' have to be of equal length.");
       }

       /* Assume are entries of 'd' all positive */
    }

    /* Verify validity of input argument 'lambda' */
    if ((mxIsEmpty(vectorB)) || (mxGetNumberOfElements(lambda) != 1) ||
        (mxGetScalar(lambda) < 0))
    {  mexErrMsgTxt("Parameter 'lambda' has to be a non-negative scalar.");
    }

    /* Get the problem size */
    n = mxGetNumberOfElements(vectorB);

    /* Replicate vector b into return argument x */
    vectorX = mxDuplicateArray(vectorB);
    plhs[0] = vectorX;


    /* Call the appropriate projection subroutine */
    if (vectorD == NULL)
    {  i = projectI(mxGetPr(vectorX), mxGetPr(vectorB), *mxGetPr(lambda), n); 
    }
    else
    {  vectorDcopy = mxDuplicateArray(vectorD);
       i = projectD(mxGetPr(vectorX),      mxGetPr(vectorB),
                    mxGetPr(vectorDcopy), *mxGetPr(lambda), n);
       mxDestroyArray(vectorDcopy);
    }

    /* Return the number of iterations for projection */
    if (nlhs > 1)
    {  plhs[1] = mxCreateDoubleScalar((double)i);
    }

    return ;
}
