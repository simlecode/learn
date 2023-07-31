// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Test {
    // int
    function test_int(int8 arg1, int16 arg2, int32 arg3, int64 arg4) public pure  returns (int64 num) {
        num = arg1 + arg2 + arg3 + arg4;
    }

    function test_int_array(int64[] memory arg) public pure returns (int64 sum) {
        sum = sumInt64(arg);
    }
    function test_multi_int_array(int8[] memory arg1, int16[] memory arg2, int32[] memory arg3, int64[] memory arg4) public pure  returns (int64 sum) {
        for(uint i = 0; i < arg1.length; i++) {
            sum = sum + arg1[i];
        }
        for(uint i = 0; i < arg2.length; i++) {
            sum = sum + arg2[i];
        }
        for(uint i = 0; i < arg3.length; i++) {
            sum = sum + arg3[i];
        }
        for(uint i = 0; i < arg4.length; i++) {
            sum = sum + arg4[i];
        }

        return sum;
    }
    function test_fixed_int_array(int64[2] memory arg) public pure returns (int64 sum) {
        sum = sumFixedInt64(arg);
    }
    function test_multi_fixed_int_array(int64[2] memory arg, int8[2] memory arg1) public pure returns (int64 sum) {
        sum = sumFixedInt64(arg);
        for(uint i = 0; i < arg1.length; i++) {
            sum = sum + arg1[i];
        }
    }
    function test_int_arrays(int64[][] memory arg) public pure  returns (int64 sum) {
        for(uint i = 0; i < arg.length; i++) {
            sum = sum + sumInt64(arg[i]);
        }
    }
    function test_fixed_int_arrays(int64[2][2] memory arg) public pure  returns (int64 sum) {
        for(uint i = 0; i < arg.length; i++) {
            sum = sum +sumFixedInt64(arg[i]);
        }
    }
    function test_left_fixed_int_arrays(int64[2][] memory arg) public pure  returns (int64 sum) {
        for(uint i = 0; i < arg.length; i++) {
            sum = sum +sumFixedInt64(arg[i]);
        }
    }
    function test_right_fixed_int_arrays(int64[][2] memory arg) public pure  returns (int64 sum) {
        for(uint i = 0; i < arg.length; i++) {
            sum = sum +sumInt64(arg[i]);
        }
    }

    // uint
    function test_uint(uint8 arg1, uint16 arg2, uint32 arg3, uint64 arg4) public pure  returns (uint64 num) {
        num = arg1 + arg2 + arg3 + arg4;
    }
    function test_uint_array(uint64[] memory arg) public pure returns (uint64 sum) {
        sum = sumUint64(arg);
    }
    function test_fixed_uint_array(uint64[2] memory arg) public pure returns (uint64 sum) {
        sum = sumFixedUint64(arg);
    }
    function test_multi_fixed_uint_array(uint64[2] memory arg, uint8[2] memory arg1) public pure returns (uint64 sum) {
        sum = sumFixedUint64(arg);
        for(uint i = 0; i < arg1.length; i++) {
            sum = sum + arg1[i];
        }
    }
    function test_uint_arrays(uint64[][] memory arg) public pure  returns (uint64 sum) {
        for(uint i = 0; i < arg.length; i++) {
            sum = sum + sumUint64(arg[i]);
        }
    }
    function test_fixed_uint_arrays(uint64[2][2] memory arg) public pure  returns (uint64 sum) {
        for(uint i = 0; i < arg.length; i++) {
            sum = sum +sumFixedUint64(arg[i]);
        }
    }
    function test_left_fixed_uint_arrays(uint64[2][] memory arg) public pure  returns (uint64 sum) {
        for(uint i = 0; i < arg.length; i++) {
            sum = sum +sumFixedUint64(arg[i]);
        }
    }
    function test_right_fixed_uint_arrays(uint64[][2] memory arg) public pure  returns (uint64 sum) {
        for(uint i = 0; i < arg.length; i++) {
            sum = sum +sumUint64(arg[i]);
        }
    }

    // test bigint
    function test_bigint(int arg1, int80 arg2, int96 arg3, int128 arg4, int160 arg5, int200 arg6, int256 arg7) public pure returns (int256 num) {
        num = arg1 + arg2 + arg3 + arg4 + arg5 + arg6 + arg7;
    }

    function test_bigint_array(int256[] memory arg) public pure returns (int256 sum) {
        sum = sum +sumBigInt256(arg);
    }
    function test_fixed_bigint_array(int256[2] memory arg) public pure returns (int256 sum) {
        sum = sum +sumFixedBigInt256(arg);
    }
    function test_multi_fixed_bigint_array(int256[2] memory arg, int128[2] memory arg1) public pure returns (int256 sum) {
        sum = sumFixedBigInt256(arg);
        for(uint i = 0; i < arg1.length; i++) {
            sum = sum + arg1[i];
        }
    }
    function test_bigint_arrays(int256[][] memory arg) public pure  returns (int256 sum) {
        for(uint i = 0; i < arg.length; i++) {
            sum = sum + sumBigInt256(arg[i]);
        }
    }
    function test_fixed_bigint_arrays(int256[2][2] memory arg) public pure  returns (int256 sum) {
        for(uint i = 0; i < arg.length; i++) {
            sum = sum +sumFixedBigInt256(arg[i]);
        }
    }
    function test_left_fixed_bigint_arrays(int256[2][] memory arg) public pure  returns (int256 sum) {
        for(uint i = 0; i < arg.length; i++) {
            sum = sum +sumFixedBigInt256(arg[i]);
        }
    }
    function test_right_fixed_bigint_arrays(int256[][2] memory arg) public pure  returns (int256 sum) {
        for(uint i = 0; i < arg.length; i++) {
            sum = sum +sumBigInt256(arg[i]);
        }
    }

    // string
    function test_string(string memory arg1, string[] memory arg2, string[][] memory arg3) public pure returns (string memory str) {
        str = string.concat(arg1, concatStr(arg2));
        for(uint i = 0; i < arg3.length; i++) {
            str = string.concat(str, concatStr(arg3[i]));
        }
    }
    function test_fixed_strings(string[2] memory arg1, string[2][2] memory arg2) public pure returns (string memory str) {
        str = concarFixedStr(arg1);
        for(uint i = 0; i < arg2.length; i++) {
            str = string.concat(str, concarFixedStr(arg2[i]));
        }
    }
    function test_multi_lstrings(string[2][] memory arg1) public pure returns (string memory str) {
        for(uint i = 0; i < arg1.length; i++) {
            str = string.concat(str, concarFixedStr(arg1[i]));
        }
    }
    function test_multi_rstrings(string[][2] memory arg1) public pure returns (string memory str) {
        for(uint i = 0; i < arg1.length; i++) {
            str = string.concat(str, concatStr(arg1[i]));
        }
    }
    function test_multi_strings(string[2][] memory arg1, string[][2] memory arg2) public pure returns (string memory str) {
        for(uint i = 0; i < arg1.length; i++) {
            str = string.concat(str, concarFixedStr(arg1[i]));
        }
        for(uint i = 0; i < arg2.length; i++) {
            str = string.concat(str, concatStr(arg2[i]));
        }
    }

    // bytes
    function test_bytes(bytes16 arg1, bytes32 arg2, bytes memory arg3) public pure returns (uint num) {
        return arg1.length + arg2.length + arg3.length;
    }
    function test_bytes_arr(bytes[] memory arg1, bytes32[] memory arg2) public pure returns (uint num) {
        for(uint i = 0;i < arg1.length; i++) {
            num = num + arg1[i].length;
        }
        return num + bytesLen(arg2);
    }
    function test_multi_bytes_arr(bytes[][] memory arg1, bytes32[][] memory arg2) public pure returns (uint num) {
        for(uint i = 0;i < arg1.length; i++) {
            num = num + arg1[i].length;
        }
        for(uint i = 0;i < arg2.length; i++) {
            num = num + arg2[i].length;
        }
    }
    function test_bytes_arrs(bytes[2][2] memory arg1, bytes32[2][] memory arg2, bytes32[][2] memory arg3) public pure returns (uint num) {
        for(uint i = 0;i < arg1.length; i++) {
            num = num + arg1[i].length;
        }
        for(uint i = 0;i < arg2.length; i++) {
            num = num + arg2[i].length;
        }
        for(uint i = 0;i < arg3.length; i++) {
            num = num + arg3[i].length;
        }
    }

    // address
    function test_address(address arg1, address[] memory arg2, address[][] memory arg3) public pure returns (address addr,uint num) {
        num = 1 + arg2.length;
        for(uint i = 0; i < arg3.length; i++) {
            num = num + arg3[i].length;
        }
        return (arg1, num);
    }
    function test_fixed_addresses(address[2] memory arg1, address[2][2] memory arg2) public pure returns (uint num) {
        num = arg1.length;
        for(uint i = 0; i < arg2.length; i++) {
            num = num + arg2[i].length;
        }
    }
    function test_multi_addresses(address[2][] memory arg1, address[][2] memory arg2) public pure returns (uint num) {
        for(uint i = 0; i < arg1.length; i++) {
            num = num + arg1[i].length;
        }
        for(uint i = 0; i < arg2.length; i++) {
            num = num + arg2[i].length;
        }
    }

     // bool
    function test_bool(bool arg1, bool[] memory arg2, bool[][] memory arg3) public pure returns (uint num, bool b) {
        b = arg1;
        num = sumBool(0, b);
        for(uint i = 0; i < arg2.length; i++) {
            num = sumBool(num, arg2[i]);
        }
        for(uint i = 0; i < arg3.length; i++) {
            for(uint j = 0; j < arg3[i].length; j++) {
                num = sumBool(num, arg3[i][j]);
            }
        }
        return (num, b);
    }
    function test_fixed_bools(bool[2] memory arg1, bool[2][2] memory arg2) public pure returns (uint num) {
        for(uint i = 0; i < arg1.length; i++) {
            num = sumBool(num, arg1[i]);
        }
        for(uint i = 0; i < arg2.length; i++) {
            for(uint j = 0; j < arg2[i].length; j++) {
                num = sumBool(num, arg2[i][j]);
            }
        }
    }
    function test_multi_bools(bool[2][] memory arg1, bool[][2] memory arg2) public pure returns (uint num) {
        for(uint i = 0; i < arg1.length; i++) {
            for(uint j = 0; j < arg1[i].length; j++) {
                num = sumBool(num, arg1[i][j]);
            }
        }
        for(uint i = 0; i < arg2.length; i++) {
            for(uint j = 0; j < arg2[i].length; j++) {
                num = sumBool(num, arg2[i][j]);
            }
        }
    }


    // utils

    function sumInt64(int64[] memory arr) internal  pure returns (int64 sum) {
        for(uint i = 0; i < arr.length; i++) {
            sum = sum + arr[i];
        }
    }
    function sumFixedInt64(int64[2] memory arr) internal  pure returns (int64 sum) {
        for(uint i = 0; i < arr.length; i++) {
            sum = sum + arr[i];
        }
    }
    function sumBigInt256(int256[] memory arr) internal  pure returns (int256 sum) {
        for(uint i = 0; i < arr.length; i++) {
            sum = sum + arr[i];
        }
    }
    function sumFixedBigInt256(int256[2] memory arr) internal  pure returns (int256 sum) {
        for(uint i = 0; i < arr.length; i++) {
            sum = sum + arr[i];
        }
    }

    function sumUint64(uint64[] memory arr) internal  pure returns (uint64 sum) {
        for(uint i = 0; i < arr.length; i++) {
            sum = sum + arr[i];
        }
    }
    function sumFixedUint64(uint64[2] memory arr) internal  pure returns (uint64 sum) {
        for(uint i = 0; i < arr.length; i++) {
            sum = sum + arr[i];
        }
    }
    function sumBigUint256(uint256[] memory arr) internal  pure returns (uint256 sum) {
        for(uint i = 0; i < arr.length; i++) {
            sum = sum + arr[i];
        }
    }
    function sumFixedBigUint256(uint256[2] memory arr) internal  pure returns (uint256 sum) {
        for(uint i = 0; i < arr.length; i++) {
            sum = sum + arr[i];
        }
    }

    function concatStr(string[] memory arr) internal pure returns (string memory str) {
        for(uint i = 0; i < arr.length; i++) {
            str = string.concat(str, arr[i]);
        }
    }
    function concarFixedStr(string[2] memory arr) internal pure returns (string memory str) {
        for(uint i = 0; i < arr.length; i++) {
            str = string.concat(str, arr[i]);
        }
    }

    function bytesLen(bytes32[] memory arr) internal pure returns (uint num) {
        for(uint i = 0;i < arr.length; i++) {
            num = num + arr[i].length;
        }
    }
    function fixedBytesLen(bytes32[2] memory arr) internal pure returns (uint num) {
        for(uint i = 0;i < arr.length; i++) {
            num = num + arr[i].length;
        }
    }

    function sumBool(uint num, bool b) internal pure returns (uint out) {
        out = num;
        if (b) {
            out = out + 1;
        }
    }
}
