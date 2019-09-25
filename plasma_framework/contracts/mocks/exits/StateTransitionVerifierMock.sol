pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "../../src/exits/interfaces/IStateTransitionVerifier.sol";

contract StateTransitionVerifierMock is IStateTransitionVerifier {
    bool public expectedResult;
    bool public shouldRevert;
    Args public expectedArgs;

    struct Args {
        bytes inFlightTx;
        bytes[] inputTxs;
        uint16[] outputIndexOfInputTxs;
    }

    /** mock what "isCorrectStateTransition()" returns */
    function mockResult(bool result) public {
        expectedResult = result;
    }

    /** when called, the "isCorrectStateTransition" function reverts on purpose */
    function mockRevert() public {
        shouldRevert = true;
    }

    /** provide the expected args, it would check with the value called for "verify()" */
    function shouldVerifyArgumentEquals(Args memory args)
        public
    {
        expectedArgs = args;
    }

    function isCorrectStateTransition(
        bytes calldata inFlightTx,
        bytes[] calldata inputTxs,
        uint16[] calldata outputIndexOfInputTxs
    )
        external
        view
        returns (bool)
    {
        if (shouldRevert) {
            // TODO: solhint disabled for now due to bug, https://github.com/protofire/solhint/issues/157
            // solhint-disable-next-line reason-string
            revert("Failing on purpose");
        }

        // only run the check when "shouldVerifyArgumentEqauals" is called
        if (expectedArgs.inFlightTx.length > 0) {
            require(keccak256(inFlightTx) == keccak256(expectedArgs.inFlightTx), "in-flight tx is not as expected");

            require(inputTxs.length == expectedArgs.inputTxs.length, "input txs array length mismatches expected data");
            for (uint i = 0; i < expectedArgs.inputTxs.length; i++) {
                require(keccak256(inputTxs[i]) == keccak256(expectedArgs.inputTxs[i]), "input tx is not as expected");
            }

            require(outputIndexOfInputTxs.length == expectedArgs.outputIndexOfInputTxs.length, "outputIndex array length mismatches expected data");
            for (uint i = 0; i < expectedArgs.outputIndexOfInputTxs.length; i++) {
                require(outputIndexOfInputTxs[i] == expectedArgs.outputIndexOfInputTxs[i], "output index of input txs is not as expected");
            }
        }

        return expectedResult;
    }
}