// SPDX-License-Identifier: MIT

pragma solidity ^0.8.22;

interface IERC20 {
    //function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    //function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract SimpleDEX {

    address owner;
    IERC20 tokenA;
    IERC20 tokenB;

    uint256 public liquidityA;
    uint256 public liquidityB;

    event LiquidityAdded(address indexed provider, uint256 amountA, uint256 amountB);
    event LiquidityRemoved(address indexed provider, uint256 amountA, uint256 amountB);
    event Swap(address indexed trader, address tokenIn, uint256 amountIn, address tokenOut, uint256 amountOut);

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Only contract owner can call this function");
        _;
    }

//Añado liquidez en pares: una cantidad válida de tokens A y otra de tokens B.
//Le sumo a la liquidez los tokens añadidos
//Emito evento que informa cambio en variable de estado
    function addLiquidity (uint256 amountA, uint256 amountB) external onlyOwner{
        require(amountA > 0 && amountB > 0, "Amounts must be greater than zero");

        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);

        liquidityA += amountA;
        liquidityB += amountB;

        emit LiquidityAdded(msg.sender, amountA, amountB);
    }

//Calculo cantidad de  tokens q recibiré al realizar intercambio bajo modelo AMM
//Aseguro liquidez del pool: Formula de producto constante (x + dx) * (y - dy) = x * y
    function amountOut(uint256 amountIn, uint256 liquidityIn, uint256 liquidityOut) private pure returns (uint256) {
        require(amountIn > 0 && liquidityIn > 0 && liquidityOut > 0, "Invalid reserves or input");
        return (amountIn * liquidityOut) / (liquidityIn + amountIn);
    }   

//Swap de tokens AforB
//Le sumo a la liquidez los tokens añadidos y resto los resultantes al exchange
//Emito evento que informa cambio en variable de estado
    function swapAforB(uint256 amountAIn) public {
        require(amountAIn > 0, "Amount must be greater than zero");
        uint256 amountBOut = amountOut (amountAIn, liquidityA, liquidityB);
        //require(amountBOut<=liquidityB, "Insufficient liquidity for this swap");

        tokenA.transferFrom(msg.sender, address(this), amountAIn);
        tokenB.transfer(msg.sender, amountBOut);

        liquidityA += amountAIn;
        liquidityB -= amountBOut;

        emit Swap(msg.sender, address(tokenA), amountAIn, address(tokenB), amountBOut);
    }


    function swapBforA(uint256 amountBIn) public {
        require(amountBIn > 0, "Amount must be greater than zero");        
        uint256 amountAOut = amountOut(amountBIn, liquidityB, liquidityA);
        //require(amountAOut<=liquidityA, "Insufficient liquidity for this swap");

        tokenB.transferFrom(msg.sender, address(this), amountBIn);
        tokenA.transfer(msg.sender, amountAOut);

        liquidityB += amountBIn;
        liquidityA -= amountAOut;

        emit Swap(msg.sender, address(tokenB), amountBIn, address(tokenA), amountAOut);
    }

//Remuevo liquidez de a pares: una cantidad válida de tokens A y otra de tokens B.
//Le resto a la liquidez los tokens removidos
//Emito evento que informa cambio en variable de estado
    function removeLiquidity(uint256 amountA, uint256 amountB) external onlyOwner{
        require(amountA <= liquidityA && amountB <= liquidityB, "Insufficient liquidity");

        liquidityA -= amountA;
        liquidityB -= amountB;

        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);

        emit LiquidityRemoved(msg.sender, amountA, amountB);
    }

//Obtención de precio del token: Verifico que la dirección ingresada sea válida.
//Si el token ingresado es TokenA, la función calcula el precio dividiendo la cantidad de TokenB en el pool entre la cantidad de TokenA. A la inversa si no es TokenA (Entonces es B)
//Multiplico por 10e18 para manejar los decimales y asegurar la precisión en los cálculos.
    function getPrice(address _token) external view returns (uint256) {
        require(_token == address(tokenA) || _token == address(tokenB), "Invalid token");

        if (_token == address(tokenA)) {
            return liquidityB * 1e18 / liquidityA;
        } else {
            return liquidityA * 1e18 / liquidityB;
        }
    }

}

//SC Scroll Sepolia 0xFD48B673359cFE9dd867b25d0A4eae883fd9be07