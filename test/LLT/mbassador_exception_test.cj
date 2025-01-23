/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights resveved.
 */
// EXEC: cjc %import-path %L %l %f entry.cj --test
// EXEC: ./main
// RESOURCES: entry.cj
import std.unittest.*
import std.unittest.testmacro.*
import mbassador4cj.*
@Test
public class MbassadorExceptionTest {

    @TestCase
    public func testMbassadorException(): Unit {
        var mbassadorException: MbassadorException = MbassadorException("testMbassadorException")
        try{
            throw mbassadorException
        }catch(e:Exception){
            @Assert(e.message,"testMbassadorException")
        }

    }
}