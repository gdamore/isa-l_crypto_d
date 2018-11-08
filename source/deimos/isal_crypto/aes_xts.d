/**********************************************************************
  Copyright(c) 2011-2016 Intel Corporation All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions
  are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in
      the documentation and/or other materials provided with the
      distribution.
    * Neither the name of Intel Corporation nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**********************************************************************/

module deimos.isal_crypto.aes_xts;

extern (C):

/**
 *  @file aes_xts.h
 *  @brief AES XTS encryption function prototypes.
 *
 * This defines the interface to optimized AES XTS functions

<b>Pre-expanded keys</b>

For key encryption, pre-expanded keys are stored in the order that they will be
used. As an example, if Key[0] is the 128-bit initial key used for an AES-128
encryption, the rest of the keys are stored as follows:

<ul>
      <li> Key[0] : Initial encryption key
      <li> Key[1] : Round 1 encryption key
      <li> Key[2] : Round 2 encryption key
      <li> ...
      <li> Key[10] : Round 10 encryption key
</ul>

For decryption, the order of keys is reversed. However, we apply the
necessary aesimc instructions before storing the expanded keys. For the same key
used above, the pre-expanded keys will be stored as follows:

<ul>
      <li> Key[0] : Round 10 encryption key
      <li> Key[1] : aesimc(Round 9 encryption key)
      <li> Key[2] : aesimc(Round 8 encryption key)
      <li> ...
      <li> Key[9] : aesimc(Round 1 encryption key)
      <li> Key[10] : Initial encryption key
</ul>

<b>Note:</b> The expanded key decryption requires a decryption key only for the block
decryption step. The tweak step in the expanded key decryption requires the same expanded
encryption key that is used in the expanded key encryption.

<b>Input and Output Buffers </b>

The input and output buffers can be overlapping as long as the output buffer
pointer is not less than the input buffer pointer. If the two pointers are the
same, then encryption/decryption will occur in-place.

<b>Data Length</b>

<ul>
    <li> The functions support data length of any bytes greater than or equal to 16 bytes.
    <li> Data length is a 64-bit value, which makes the largest possible data length
         2^64 - 1 bytes.
    <li> For data lengths from 0 to 15 bytes, the functions return without any error
         codes, without reading or writing any data.
    <li> The functions only support byte lengths, not bits.
</ul>

<b>Initial Tweak</b>

The functions accept a 128-bit initial tweak value. The user is responsible for
padding the initial tweak value to this length.

<b>Data Alignment</b>

The input and output buffers, keys, pre-expanded keys and initial tweak value
are not required to be aligned to 16 bytes, any alignment works.

 */

/** @brief XTS-AES-128 Encryption
 * @requires AES-NI
 */

//!<  key used for tweaking, 16 bytes
//!<  key used for encryption of tweaked plaintext, 16 bytes
//!<  initial tweak value, 16 bytes
//!<  sector size, in bytes
//!<  plaintext sector input data
//!<  ciphertext sector output data
void XTS_AES_128_enc (
    ubyte* k2,
    ubyte* k1,
    ubyte* TW_initial,
    ulong N,
    const(ubyte)* pt,
    ubyte* ct);

/** @brief XTS-AES-128 Encryption with pre-expanded keys
 * @requires AES-NI
 */

//!<  expanded key used for tweaking, 16*11 bytes
//!<  expanded key used for encryption of tweaked plaintext, 16*11 bytes
//!<  initial tweak value, 16 bytes
//!<  sector size, in bytes
//!<  plaintext sector input data
//!<  ciphertext sector output data
void XTS_AES_128_enc_expanded_key (
    ubyte* k2,
    ubyte* k1,
    ubyte* TW_initial,
    ulong N,
    const(ubyte)* pt,
    ubyte* ct);

/** @brief XTS-AES-128 Decryption
 * @requires AES-NI
 */

//!<  key used for tweaking, 16 bytes
//!<  key used for decryption of tweaked ciphertext, 16 bytes
//!<  initial tweak value, 16 bytes
//!<  sector size, in bytes
//!<  ciphertext sector input data
//!<  plaintext sector output data
void XTS_AES_128_dec (
    ubyte* k2,
    ubyte* k1,
    ubyte* TW_initial,
    ulong N,
    const(ubyte)* ct,
    ubyte* pt);

/** @brief XTS-AES-128 Decryption with pre-expanded keys
 * @requires AES-NI
 */

//!<  expanded key used for tweaking, 16*11 bytes - encryption key is used
//!<  expanded decryption key used for decryption of tweaked ciphertext, 16*11 bytes
//!<  initial tweak value, 16 bytes
//!<  sector size, in bytes
//!<  ciphertext sector input data
//!<  plaintext sector output data
void XTS_AES_128_dec_expanded_key (
    ubyte* k2,
    ubyte* k1,
    ubyte* TW_initial,
    ulong N,
    const(ubyte)* ct,
    ubyte* pt);

/** @brief XTS-AES-256 Encryption
 * @requires AES-NI
 */

//!<  key used for tweaking, 16*2 bytes
//!<  key used for encryption of tweaked plaintext, 16*2 bytes
//!<  initial tweak value, 16 bytes
//!<  sector size, in bytes
//!<  plaintext sector input data
//!<  ciphertext sector output data
void XTS_AES_256_enc (
    ubyte* k2,
    ubyte* k1,
    ubyte* TW_initial,
    ulong N,
    const(ubyte)* pt,
    ubyte* ct) nothrow @nogc;

/** @brief XTS-AES-256 Encryption with pre-expanded keys
 * @requires AES-NI
 */

//!<  expanded key used for tweaking, 16*15 bytes
//!<  expanded key used for encryption of tweaked plaintext, 16*15 bytes
//!<  initial tweak value, 16 bytes
//!<  sector size, in bytes
//!<  plaintext sector input data
//!<  ciphertext sector output data
void XTS_AES_256_enc_expanded_key (
    ubyte* k2,
    ubyte* k1,
    ubyte* TW_initial,
    ulong N,
    const(ubyte)* pt,
    ubyte* ct);

/** @brief XTS-AES-256 Decryption
 * @requires AES-NI
 */

//!<  key used for tweaking, 16*2 bytes
//!<  key used for  decryption of tweaked ciphertext, 16*2 bytes
//!<  initial tweak value, 16 bytes
//!<  sector size, in bytes
//!<  ciphertext sector input data
//!<  plaintext sector output data
void XTS_AES_256_dec (
    ubyte* k2,
    ubyte* k1,
    ubyte* TW_initial,
    ulong N,
    const(ubyte)* ct,
    ubyte* pt) nothrow @nogc;

/** @brief XTS-AES-256 Decryption with pre-expanded keys
 * @requires AES-NI
 */

//!<  expanded key used for tweaking, 16*15 bytes - encryption key is used
//!<  expanded decryption key used for decryption of tweaked ciphertext, 16*15 bytes
//!<  initial tweak value, 16 bytes
//!<  sector size, in bytes
//!<  ciphertext sector input data
//!<  plaintext sector output data
void XTS_AES_256_dec_expanded_key (
    ubyte* k2,
    ubyte* k1,
    ubyte* TW_initial,
    ulong N,
    const(ubyte)* ct,
    ubyte* pt);

//_AES_XTS_H
