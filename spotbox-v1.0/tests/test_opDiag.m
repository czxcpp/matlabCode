function test_suite = test_opDiag
%test_opDiag  Unit tests for the opDiag operator
initTestSuite;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function seed = setup
   randn('state',0);
   rand('state',0);
   seed = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
function test_opDiag_diag(seed)
   n = randi(100); k = randi(10);

   b = randn(n,k);
   d = randn(n,1);
   D = opDiag(d);
   
   assertEqual( diag(double(D)), d )
   assertEqual( diag(d)\b, D\b )
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
function test_opDiag_class(seed)
   n = randi(100);
   d = randn(n,1);
   assertEqual( double(diag(d)), double(opDiag(d)) ) 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
function test_opDiag_divide(seed)
   n = randi(100);
   d = randn(n,1) + 1i*randn(n,1);
   b = randn(n,1) + 1i*randn(n,1);
   D = opDiag(d);
   assertEqual( D\b,  d.\b ) 
   assertEqual( D'\b, conj(d).\b )
   assertEqual( D.'\b, d.\b ) 
end
