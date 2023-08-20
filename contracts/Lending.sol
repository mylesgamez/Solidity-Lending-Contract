// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Lending {
    struct Loan {
        uint256 principal;
        uint256 interest;
        uint256 dueDate;
        uint256 period;
        address collateralToken;
        uint256 collateralAmount;
    }

    address public owner;
    mapping(address => Loan) public loans;
    uint256 public interestRate = 10; // 10% interest rate

    event LoanRequested(
        address indexed borrower,
        uint256 amount,
        uint256 dueDate,
        uint256 period
    );
    event LoanRepaid(address indexed borrower, uint256 amount);
    event CollateralDeposited(
        address indexed borrower,
        address token,
        uint256 amount
    );
    event CollateralReleased(address indexed borrower);
    event CollateralLiquidated(address indexed borrower);

    constructor() {
        owner = msg.sender;
    }

    function lend(address borrower, uint256 amount, uint256 period) public {
        require(msg.sender == owner, "Only the owner can lend money");

        uint256 interest = (amount * interestRate) / 100;
        uint256 dueDate = block.timestamp + period;

        loans[borrower] = Loan({
            principal: amount,
            interest: interest,
            dueDate: dueDate,
            period: period,
            collateralToken: address(0),
            collateralAmount: 0
        });

        emit LoanRequested(borrower, amount, dueDate, period);
    }

    function depositCollateral(address token, uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");
        IERC20 collateralToken = IERC20(token);
        require(
            collateralToken.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );

        Loan storage loan = loans[msg.sender];
        loan.collateralToken = token;
        loan.collateralAmount = amount;

        emit CollateralDeposited(msg.sender, token, amount);
    }

    function repayLoan(uint256 amount) public {
        Loan storage loan = loans[msg.sender];

        require(
            loan.principal + loan.interest >= amount,
            "Repayment amount exceeds loan amount"
        );
        require(block.timestamp <= loan.dueDate, "Repayment period has passed");

        if (amount == loan.principal + loan.interest) {
            // If the loan is fully repaid, release the collateral
            if (loan.collateralAmount > 0) {
                IERC20 collateralToken = IERC20(loan.collateralToken);
                require(
                    collateralToken.transfer(msg.sender, loan.collateralAmount),
                    "Transfer failed"
                );
                emit CollateralReleased(msg.sender);
            }

            delete loans[msg.sender];
        } else {
            loan.principal -= amount;
            loan.interest = (loan.principal * interestRate) / 100;
        }

        emit LoanRepaid(msg.sender, amount);
    }

    function liquidateCollateral(address borrower) public {
        require(msg.sender == owner, "Only the owner can liquidate collateral");
        Loan storage loan = loans[borrower];
        require(
            block.timestamp > loan.dueDate,
            "Repayment period has not passed"
        );

        if (loan.collateralAmount > 0) {
            IERC20 collateralToken = IERC20(loan.collateralToken);
            require(
                collateralToken.transfer(owner, loan.collateralAmount),
                "Transfer failed"
            );
            emit CollateralLiquidated(borrower);
        }

        delete loans[borrower];
    }

    function checkLoan(
        address borrower
    )
        public
        view
        returns (
            uint256 principal,
            uint256 interest,
            uint256 dueDate,
            uint256 period,
            address collateralToken,
            uint256 collateralAmount
        )
    {
        Loan memory loan = loans[borrower];
        return (
            loan.principal,
            loan.interest,
            loan.dueDate,
            loan.period,
            loan.collateralToken,
            loan.collateralAmount
        );
    }
}
