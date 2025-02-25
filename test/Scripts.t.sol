import {Test} from "forge-std/Test.sol";
import {Test} from "forge-std/Test.sol";
import {ArrayScript} from "../script/Array.s.sol";
import {MappingScript} from "../script/Mapping.s.sol";
import {StringScript} from "../script/String.s.sol";

contract Scipts is Test {
    function test_Array() public {
        ArrayScript script = new ArrayScript();
        script.run();
    }

    function test_Mapping() public {
        MappingScript script = new MappingScript();
        script.run();
    }

    function test_String() public {
        StringScript script = new StringScript();
        script.run();
    }
}
