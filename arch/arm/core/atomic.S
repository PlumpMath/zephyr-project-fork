/*
 * Copyright (c) 2013-2014 Wind River Systems, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @file
 * @brief ARM atomic operations library
 *
 * This library provides routines to perform a number of atomic operations
 * on a memory location: add, subtract, increment, decrement, bitwise OR,
 * bitwise NOR, bitwise AND, bitwise NAND, set, clear and compare-and-swap.
 */

#define _ASMLANGUAGE

#include <toolchain.h>
#include <sections.h>

_ASM_FILE_PROLOGUE

/* exports */

GTEXT(atomic_set)
GTEXT(atomic_get)
GTEXT(atomic_add)
GTEXT(atomic_nand)
GTEXT(atomic_and)
GTEXT(atomic_or)
GTEXT(atomic_xor)
GTEXT(atomic_clear)
GTEXT(atomic_dec)
GTEXT(atomic_inc)
GTEXT(atomic_sub)
GTEXT(atomic_cas)

/**
 *
 * @brief Atomically clear a memory location
 *
 * This routine atomically clears the contents of <target> and returns the old
 * value that was in <target>.
 *
 * This routine can be used from both task and interrupt level.
 *
 * @return Contents of <target> before the atomic operation
 *
 * ERRNO: N/A
 *
 * atomic_val_t atomic_clear
 *    (
 *    atomic_t *target	/@ memory location to clear @/
 *    )
 */

SECTION_SUBSEC_FUNC(TEXT, atomic_clear_set, atomic_clear)
	MOV	r1, #0
	/* fall through into atomic_set */

/**
 *
 * @brief Atomically set a memory location
 *
 * This routine atomically sets the contents of <target> to <value> and returns
 * the old value that was in <target>.
 *
 * This routine can be used from both task and interrupt level.
 *
 * @return Contents of <target> before the atomic operation
 *
 * ERRNO: N/A
 *
 * atomic_val_t atomic_set
 *    (
 *    atomic_t *target,	/@ memory location to set @/
 *    atomic_val_t value	/@ set with this value @/
 *    )
 *
 */

SECTION_SUBSEC_FUNC(TEXT, atomic_clear_set, atomic_set)

	LDREX	r2, [r0]	/* load old value and mark exclusive access */
	STREX	r12, r1, [r0]	/* try to store new value */
	TEQ	r12, #0		/* store successful? */

	BNE	atomic_set	/* if not, retry */

	MOV	r0, r2		/* return old value */
	MOV	pc, lr

/**
 *
 * @brief Get the value of a shared memory atomically
 *
 * This routine atomically retrieves the value in *target
 *
 * long atomic_get
 *     (
 *     atomic_t * target    /@ address of atom to be retrieved @/
 *     )
 *
 * RETURN: value read from address target.
 *
 */

SECTION_FUNC(TEXT, atomic_get)
	LDR	r0, [r0]
	MOV	pc, lr

/**
 *
 * @brief Atomically increment a memory location
 *
 * This routine atomically increments the value in <target>.  The operation is
 * done using unsigned integer arithmetic.  Various CPU architectures may impose
 * restrictions with regards to the alignment and cache attributes of the
 * atomic_t type.
 *
 * This routine can be used from both task and interrupt level.
 *
 * @return Contents of <target> before the atomic operation
 *
 * ERRNO: N/A
 *
 * atomic_val_t atomic_inc
 *    (
 *    atomic_t *target,	/@ memory location to increment @/
 *    )
 *
 */

SECTION_SUBSEC_FUNC(TEXT, atomic_inc_add, atomic_inc)
	MOV	r1, #1
	/* fall through into atomic_add */

/**
 *
 * @brief Atomically add a value to a memory location
 *
 * This routine atomically adds the contents of <target> and <value>, placing
 * the result in <target>. The operation is done using signed integer arithmetic.
 * Various CPU architectures may impose restrictions with regards to the
 * alignment and cache attributes of the atomic_t type.
 *
 * This routine can be used from both task and interrupt level.
 *
 * @return Contents of <target> before the atomic operation
 *
 * ERRNO: N/A
 *
 * atomic_val_t atomic_add
 *    (
 *    atomic_t *target,	/@ memory location to add to @/
 *    atomic_val_t value	/@ value to add @/
 *    )
 */

SECTION_SUBSEC_FUNC(TEXT, atomic_inc_add, atomic_add)

	LDREX	r2, [r0]	/* load old value and mark exclusive access */
	ADD	r3, r2, r1	/* add word */
	STREX	r12, r3, [r0]	/* try to store new value */
	TEQ	r12, #0		/* store successful? */

	BNE	atomic_add	/* if not, retry */

	MOV	r0, r2		/* return old value */
	MOV	pc, lr

/**
 *
 * @brief Atomically decrement a memory location
 *
 * This routine atomically decrements the value in <target>.  The operation is
 * done using unsigned integer arithmetic.  Various CPU architectures may impose
 * restrictions with regards to the alignment and cache attributes of the
 * atomic_t type.
 *
 * This routine can be used from both task and interrupt level.
 *
 * @return Contents of <target> before the atomic operation
 *
 * ERRNO: N/A
 *
 * atomic_val_t atomic_dec
 *    (
 *    atomic_t *target,	/@ memory location to decrement @/
 *    )
 *
 */

SECTION_SUBSEC_FUNC(TEXT, atomic_decSub, atomic_dec)
	MOV   r1, #1
	/* fall through into atomic_sub */

/**
 *
 * @brief Atomically subtract a value from a memory location
 *
 * This routine atomically subtracts <value> from the contents of <target>,
 * placing the result in <target>.  The operation is done using signed integer
 * arithmetic. Various CPU architectures may impose restrictions with regards to
 * the alignment and cache attributes of the atomic_t type.
 *
 * This routine can be used from both task and interrupt level.
 *
 * @return Contents of <target> before the atomic operation
 *
 * ERRNO: N/A
 *
 * atomic_val_t atomic_sub
 *    (
 *    atomic_t *target,	/@ memory location to subtract from @/
 *    atomic_val_t value	/@ value to subtract @/
 *    )
 *
 */

SECTION_SUBSEC_FUNC(TEXT, atomic_decSub, atomic_sub)

	LDREX	r2, [r0]	/* load old value and mark exclusive access */
	SUB	r3, r2, r1	/* subtract word */
	STREX	r12, r3, [r0]	/* try to store new value */
	TEQ	r12, #0		/* store successful? */
	BNE	atomic_sub	/* if not, retry */

	MOV	r0, r2		/* return old value */
	MOV	pc, lr

/**
 *
 * @brief Atomically perform a bitwise NAND on a memory location
 *
 * This routine atomically performs a bitwise NAND operation of the contents of
 * <target> and <value>, placing the result in <target>.
 * Various CPU architectures may impose restrictions with regards to the
 * alignment and cache attributes of the atomic_t type.
 *
 * This routine can be used from both task and interrupt level.
 *
 * @return Contents of <target> before the atomic operation
 *
 * ERRNO: N/A
 *
 * atomic_val_t atomic_nand
 *    (
 *    atomic_t *target,	/@ memory location to NAND @/
 *    atomic_val_t value	/@ NAND with this value @/
 *    )
 *
 */

SECTION_FUNC(TEXT, atomic_nand)

	LDREX	r2, [r0]	/* load old value and mark exclusive access */
	AND	r3, r2, r1	/* AND word */
	MVN	r3, r3		/* invert */
	STREX	r12, r3, [r0]	/* try to store new value */
	TEQ	r12, #0		/* store successful? */
	BNE	atomic_nand	/* if not, retry */

	MOV	r0, r2		/* return old value */
	MOV	pc, lr

/**
 *
 * @brief Atomically perform a bitwise AND on a memory location
 *
 * This routine atomically performs a bitwise AND operation of the contents of
 * <target> and <value>, placing the result in <target>.
 * Various CPU architectures may impose restrictions with regards to the
 * alignment and cache attributes of the atomic_t type.
 *
 * This routine can be used from both task and interrupt level.
 *
 * @return Contents of <target> before the atomic operation
 *
 * ERRNO: N/A
 *
 * atomic_val_t atomic_and
 *    (
 *    atomic_t *target,	/@ memory location to AND @/
 *    atomic_val_t value	/@ AND with this value @/
 *    )
 *
 */

SECTION_FUNC(TEXT, atomic_and)

	LDREX	r2, [r0]	/* load old value and mark exclusive access */
	AND	r3, r2, r1	/* AND word */
	STREX	r12, r3, [r0]	/* try to store new value */
	TEQ	r12, #0		/* store successful? */
	BNE	atomic_and	/* if not, retry */

	MOV	r0, r2		/* return old value */
	MOV	pc, lr

/**
 *
 * @brief Atomically perform a bitwise OR on memory location
 *
 * This routine atomically performs a bitwise OR operation of the contents of
 * <target> and <value>, placing the result in <target>.
 * Various CPU architectures may impose restrictions with regards to the
 * alignment and cache attributes of the atomic_t type.
 *
 * This routine can be used from both task and interrupt level.
 *
 * @return Contents of <target> before the atomic operation
 *
 * ERRNO: N/A
 *
 * atomic_val_t atomic_or
 *    (
 *    atomic_t *target,	/@ memory location to OR @/
 *    atomic_val_t value	/@ OR with this value @/
 *    )
 *
 */

SECTION_FUNC(TEXT, atomic_or)

	LDREX	r2, [r0]	/* load old value and mark exclusive access */
	ORR	r3, r2, r1	/* OR word */
	STREX	r12, r3, [r0]	/* try to store new value */
	TEQ	r12, #0		/* store successful? */
	BNE	atomic_or	/* if not, retry */

	MOV	r0, r2		/* return old value */
	MOV	pc, lr

/**
 *
 * @brief Atomically perform a bitwise XOR on a memory location
 *
 * This routine atomically performs a bitwise XOR operation of the contents of
 * <target> and <value>, placing the result in <target>.
 * Various CPU architectures may impose restrictions with regards to the
 * alignment and cache attributes of the atomic_t type.
 *
 * This routine can be used from both task and interrupt level.
 *
 * @return Contents of <target> before the atomic operation
 *
 * ERRNO: N/A
 *
 * atomic_val_t atomic_xor
 *    (
 *    atomic_t *target,	/@ memory location to XOR @/
 *    atomic_val_t value	/@ XOR with this value @/
 *    )
 *
 */

SECTION_FUNC(TEXT, atomic_xor)

	LDREX	r2, [r0]	/* load old value and mark exclusive access */
	EOR	r3, r2, r1	/* XOR word */
	STREX	r12, r3, [r0]	/* try to store new value */
	TEQ	r12, #0		/* store successful? */
	BNE	atomic_xor	/* if not, retry */

	MOV	r0, r2		/* return old value */
	MOV	pc, lr

/**
 *
 * @brief Atomically compare-and-swap the contents of a memory location
 *
 * This routine performs an atomic compare-and-swap. testing that the contents of
 * <target> contains <oldValue>, and if it does, setting the value of <target>
 * to <newValue>. Various CPU architectures may impose restrictions with regards
 * to the alignment and cache attributes of the atomic_t type.
 *
 * This routine can be used from both task and interrupt level.
 *
 * @return 1 if the swap is actually executed, 0 otherwise.
 *
 * ERRNO: N/A
 *
 * int atomic_cas
 *    (
 *    atomic_t *target,	        /@ memory location to compare-and-swap @/
 *    atomic_val_t oldValue,	/@ compare to this value @/
 *    atomic_val_t newValue,	/@ swap with this value @/
 *    )
 *
 */

SECTION_FUNC(TEXT, atomic_cas)

	LDREX	r3, [r0]	/* load the value and mark exclusive access */
	CMP	r3, r1		/* if (*target != oldValue) */
	ITT NE
	    MOVNE	r0, #0		/*     return FALSE */
	    MOVNE	pc, lr
	STREX	r12, r2, [r0]	/* try to store if equal */
	TEQ	r12, #0		/* store successful? */
	BNE	atomic_cas	/* if not, retry */

	MOV	r0, #1		/* return TRUE if swap occurred */
	MOV	pc, lr
