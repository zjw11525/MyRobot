////////////////////////////////////////////////////////////////////////////////
//        File: TcAdsAPI.h
// Description: Prototypes and Definitions for non C++ Applications
//      Author: RamonB
//     Created: Wed Nov 6 10:00:00 1996
//
//
// BECKHOFF-Industrieelektronik-GmbH
//
// Modifications:	
// KlausBue 11/1999
// Register Callback for Router notifications
//
// ChristophC 16/07/2001
// Double definition of router callback function removed 
// 
////////////////////////////////////////////////////////////////////////////////
#ifndef __ADSAPI_H__
#define __ADSAPI_H__

#define ADSAPIERR_NOERROR			0x0000

////////////////////////////////////////////////////////////////////////////////
#ifdef __cplusplus
extern "C"
{
#endif

__declspec( dllexport ) 
long __stdcall AdsGetDllVersion( void );

__declspec( dllexport )
long	__stdcall AdsPortOpen( void ); 

__declspec( dllexport )
long	__stdcall AdsPortClose( void );

__declspec( dllexport )
long	__stdcall AdsGetLocalAddress( AmsAddr*	pAddr );
 
__declspec( dllexport )
long __stdcall AdsSyncWriteReq(	AmsAddr*	pServerAddr,	// Ams address of ADS server
							 unsigned long	indexGroup,		//	index group in ADS server interface
							 unsigned long	indexOffset,	// index offset in ADS server interface
							 unsigned long	length,			// count of bytes to write
							 void*				pData				// pointer to the client buffer
							);

__declspec( dllexport )
long __stdcall AdsSyncReadReq( AmsAddr*	pAddr,						// Ams address of ADS server           
							 unsigned long		indexGroup,		//	index group in ADS server interface
							 unsigned long		indexOffset,	// index offset in ADS server interface
							 unsigned long		length,			// count of bytes to read
							 void*				pData				// pointer to the client buffer
							);

__declspec( dllexport )
long __stdcall AdsSyncReadReqEx( AmsAddr*	pAddr,						// Ams address of ADS server           
							 unsigned long		indexGroup,		//	index group in ADS server interface
							 unsigned long		indexOffset,	// index offset in ADS server interface
							 unsigned long		length,			// count of bytes to read
							 void*				pData,			// pointer to the client buffer
							 unsigned long*	pcbReturn		// count of bytes read
							);

__declspec( dllexport )
long __stdcall AdsSyncReadWriteReq( AmsAddr* pAddr,					// Ams address of ADS server
							unsigned long indexGroup,			//	index group in ADS server interface
							unsigned long indexOffset,			// index offset in ADS server interface
							unsigned long cbReadLength,		// count of bytes to read
							void* pReadData,						// pointer to the client buffer
							unsigned long cbWriteLength, 		// count of bytes to write
							void* pWriteData						// pointer to the client buffer
							);											

__declspec( dllexport )
long __stdcall AdsSyncReadWriteReqEx( AmsAddr* pAddr,					// Ams address of ADS server
							unsigned long indexGroup,			//	index group in ADS server interface
							unsigned long indexOffset,			// index offset in ADS server interface
							unsigned long cbReadLength,		// count of bytes to read
							void* pReadData,						// pointer to the client buffer
							unsigned long cbWriteLength, 		// count of bytes to write
							void* pWriteData,						// pointer to the client buffer
							unsigned long*	pcbReturn			// count of bytes read
							);											

__declspec( dllexport )
long __stdcall AdsSyncReadDeviceInfoReq( AmsAddr*		pAddr,	// Ams address of ADS server 
										 char*			pDevName,// fixed length string (16 Byte)
										 AdsVersion*	pVersion	// client buffer to store server version
										 );

__declspec( dllexport )
long __stdcall AdsSyncWriteControlReq( AmsAddr*		  pAddr,	   // Ams address of ADS server           
									  unsigned short adsState, // index group in ADS server interface 
									  unsigned short deviceState,// index offset in ADS server interface
									  unsigned long length,	// count of bytes to write
									  void*			  pData		// pointer to the client buffer        
									  );

__declspec( dllexport )
long __stdcall AdsSyncReadStateReq( AmsAddr*	pAddr,				// Ams address of ADS server           
								  unsigned short*	pAdsState,	// pointer to client buffer
								  unsigned short*	pDeviceState// pointer to the client buffer        
								  );							          


__declspec( dllexport )
long __stdcall AdsSyncAddDeviceNotificationReq(	AmsAddr*	pAddr, 	// Ams address of ADS server           
													unsigned long indexGroup, //	index group in ADS server interface
													unsigned long indexOffset,//	index offset in ADS server interface
													AdsNotificationAttrib* pNoteAttrib,	// attributes of notification request
													PAdsNotificationFuncEx pNoteFunc,		// address of notification callback
													unsigned long hUser,						// user handle
													unsigned long *pNotification			// pointer to notification handle (return value)
													);
__declspec( dllexport )
long __stdcall AdsSyncDelDeviceNotificationReq(	AmsAddr*	pAddr,// Ams address of ADS server            
													unsigned long hNotification // notification handle
													);

__declspec( dllexport )
long __stdcall AdsSyncSetTimeout(	long nMs ); // Set timeout in ms


__declspec( dllexport )
long __stdcall AdsGetLastError( void ); 


/// register callback
__declspec( dllexport )
long __stdcall AdsAmsRegisterRouterNotification (PAmsRouterNotificationFuncEx pNoteFunc );

/// unregister callback
__declspec( dllexport )
long __stdcall AdsAmsUnRegisterRouterNotification ();


__declspec( dllexport )
long  __stdcall AdsSyncGetTimeout(long *pnMs ); // client buffer to store timeout

__declspec( dllexport )
long __stdcall AdsAmsPortEnabled(BOOL *pbEnabled);


////////////////////////////////////////////////////////////////////////////////////////////////////
// new Ads functions for multithreading applications
__declspec( dllexport )
long __stdcall AdsPortOpenEx( ); 

__declspec( dllexport )
long	__stdcall AdsPortCloseEx( long port );

__declspec( dllexport )
long	__stdcall AdsGetLocalAddressEx(long port, AmsAddr*	pAddr );
 
__declspec( dllexport )
long __stdcall AdsSyncWriteReqEx( long	port,				// Ams port of ADS client
							 AmsAddr*			pServerAddr,	// Ams address of ADS server
							 unsigned long		indexGroup,		//	index group in ADS server interface
							 unsigned long		indexOffset,	// index offset in ADS server interface
							 unsigned long		length,			// count of bytes to write
							 void*				pData				// pointer to the client buffer
							 );

__declspec( dllexport )
long __stdcall AdsSyncReadReqEx2( long	port,				// Ams port of ADS client
							 AmsAddr*			pServerAddr,	// Ams address of ADS server
							 unsigned long		indexGroup,		//	index group in ADS server interface
							 unsigned long		indexOffset,	// index offset in ADS server interface
							 unsigned long		length,			// count of bytes to read
							 void*				pData,				// pointer to the client buffer
							 unsigned long*	pcbReturn		// count of bytes read
							);


__declspec( dllexport )
long  __stdcall AdsSyncReadWriteReqEx2( long	port,		// Ams port of ADS client
							AmsAddr*				pServerAddr,	// Ams address of ADS server
							unsigned long		indexGroup,		//	index group in ADS server interface
							unsigned long		indexOffset,	// index offset in ADS server interface
							unsigned long		cbReadLength,	// count of bytes to read
							void*					pReadData,		// pointer to the client buffer
							unsigned long		cbWriteLength, // count of bytes to write
							void*					pWriteData,		// pointer to the client buffer
							unsigned long*		pcbReturn		// count of bytes read
							);											

__declspec( dllexport )
long  __stdcall AdsSyncReadDeviceInfoReqEx( long port,		// Ams port of ADS client
										 AmsAddr*		pServerAddr,	// Ams address of ADS server
										 char*			pDevName,		// fixed length string (16 Byte)
										 AdsVersion*	pVersion			// client buffer to store server version
										 );

__declspec( dllexport )
long  __stdcall AdsSyncWriteControlReqEx( long port,			// Ams port of ADS client
									  AmsAddr*			pServerAddr,	// Ams address of ADS server
									  unsigned short	adsState,		// index group in ADS server interface 
									  unsigned short	deviceState,	// index offset in ADS server interface
									  unsigned long	length,			// count of bytes to write
									  void*				pData				// pointer to the client buffer        
									  );

__declspec( dllexport )
long  __stdcall AdsSyncReadStateReqEx( long port,			// Ams port of ADS client
								  AmsAddr*			pServerAddr,	// Ams address of ADS server
								  unsigned short*	pAdsState,		// pointer to client buffer
								  unsigned short*	pDeviceState	// pointer to the client buffer        
								  );							          


__declspec( dllexport )
long  __stdcall AdsSyncAddDeviceNotificationReqEx(	long port,							// Ams port of ADS client
													AmsAddr*			pServerAddr,					// Ams address of ADS ser
													unsigned long indexGroup,						//	index group in ADS server interface
													unsigned long indexOffset,						//	index offset in ADS server interface
													AdsNotificationAttrib* pNoteAttrib,			// attributes of notification request
													PAdsNotificationFuncEx pNoteFunc,				// address of notification callback
													unsigned long hUser,								// user handle
													unsigned long *pNotification					// pointer to notification handle (return value)
													);
__declspec( dllexport )
long  __stdcall AdsSyncDelDeviceNotificationReqEx( long port,							// Ams port of ADS client
													AmsAddr*			pServerAddr,					// Ams address of ADS ser
													unsigned long hNotification					// notification handle
													);

__declspec( dllexport )
long  __stdcall AdsSyncSetTimeoutEx(long port, // Ams port of ADS client
							  long nMs ); // Set timeout in ms

__declspec( dllexport )
long  __stdcall AdsSyncGetTimeoutEx(long port,   // Ams port of ADS client
							  long *pnMs ); // client buffer to store timeout

__declspec( dllexport )
long __stdcall AdsAmsPortEnabledEx(long nPort, BOOL *pbEnabled);


#ifdef __cplusplus
} // extern "C"
#endif
#endif