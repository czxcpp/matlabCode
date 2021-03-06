/* FDCT3D (Fast 3d Curvelet Transform)
   Copyright (C) 2004 Caltech
	Written by Lexing Ying
*/

#ifndef _NUMVEC_HPP_
#define _NUMVEC_HPP_

#include "commoninc.hpp"

//-------------------------------------------------
template <class F>
class NumVec {
public:
  int _m;
  F* _data;
public:
  NumVec(int m=0): _m(m) {
	 if(_m>0) {		_data = new F[_m]; assert( _data!=NULL );	 memset(_data, 0, _m*sizeof(F));	 } else		_data=NULL;
  }
  NumVec(const NumVec& C): _m(C._m) {
	 if(_m>0) {		_data = new F[_m]; assert( _data!=NULL );	 memset(_data, 0, _m*sizeof(F));	 } else 		_data=NULL;
	 if(_m>0) {		memcpy( _data, C._data, _m*sizeof(F) );	 }
  }
  ~NumVec() {
	 if(_m>0) {		delete[] _data; _data = NULL;	 }
  }
  NumVec& operator=(const NumVec& C) {
	 if(_m>0) {		delete[] _data; _data = NULL;	 }
	 _m = C._m;
	 if(_m>0) {		_data = new F[_m]; assert( _data!=NULL );	 memset(_data, 0, _m*sizeof(F));	 } else		_data = NULL;
	 if(_m>0) {		memcpy( _data, C._data, _m*sizeof(F) );	 }
	 return *this;
  }
  void resize(int m)  {
	 if(_m!=m) {
		if(_m>0) {		  delete[] _data; _data = NULL;		}
		_m = m;
		if(_m>0) {		  _data = new F[_m]; assert( _data!=NULL );		memset(_data, 0, _m*sizeof(F));		}		else		  _data = NULL;
	 }
  }
  const F& operator()(int i) const  {	 assert( i>=0 && i<_m);
	 return _data[i];
  }
  F& operator()(int i)  { 	 assert( i>=0 && i<_m);
	 return _data[i];
  }
  int m() const { return _m; }
  F* data() const { return _data; }
};

//INPUT template <class F> inline istream& operator>>(istream& is, NumVec<F>& vec)
//OUTPUT template <class F> inline ostream& operator<<(ostream& os, const NumVec<F>& vec)

template <class F> inline void setvalue(NumVec<F>& vec, F val)
{
  for(int i=0; i<vec.m(); i++)
	vec(i) = val;
}
//template <class F> inline void clear(NumVec<F>& vec){  memset(vec.data(), 0, vec.m()*sizeof(F));}

typedef NumVec<bool>   BolNumVec;
typedef NumVec<char>   ChrNumVec;
typedef NumVec<int>    IntNumVec;
typedef NumVec<double> DblNumVec;
typedef NumVec<cpx>    CpxNumVec;

#endif

