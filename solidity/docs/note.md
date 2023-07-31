# solidity

## Visibility

可见性说明符用于控制谁有权访问函数和状态变量。总共有四种可见性说明符。

* external：其它合约调用，state 不可以使用
* public：本合约、子合约和其它合约调用
* internal：本合约和子合约调用
* private：本合约内部调用


## Control Flow

* if、else、else if
* 三目运算：uint out = _x < 10 ? 1 : 2;
* for、while、do while、continue、break

## Data Structures

数组、映射和结构都是引用类型。 与值类型（例如布尔值或整数）不同，引用类型不直接存储它们的值。 相反，它们存储值的存储位置。
多个引用类型变量可以引用同一位置，并且一个变量的更改会影响其他变量，因此需要小心处理。

### Arrays

在 `Solidity` 中，数组存储按数字索引的相同类型值的有序列表。

有两种类型的数组，一种是固定大小，一种是动态。

```solidity
var uint[] arr;

# 数组长度
arr.length
# push，在数组末尾追加一个元素
arr.push(1);
# pop，移除最后一个元素
arr.pop();
# delete，重置一个元素为 0 值，数组长度不变
delete arr[0];
# 下标访问，越界会出错
arr[0];
```

### Mappings

> mapping(KeyType => ValueType) VariableName 键类型可以是任何内置值类型或任何合约，但不能是引用类型，值类型可以是任何类型。

在 `Solidity` 中，映射是键类型和相应值类型对的集合。

映射和数组之间最大的区别是不能迭代，也就是不能使用循环变量元素。 如果不知道 `key`，我们将无法访问它的值。 如果需要了解所有数据或迭代它，应该使用数组。
可以将 `mapping` 的键存储在数组中，这样就可以迭代 `mapping`。

```solidity
var mapping(address => bool);

# 增加
mapping[addr] = true;
# 获取，不存在返回默认值
bool b = mapping[addr];
# 删除，把值改为默认值
delete mapping[addr];
```

### Structs

在 `Solidity` 中，可以以结构体的形式定义自定义数据类型，结构体是可以包含不同数据类型的变量的集合。使用 `struct` 关键字定义一个结构体。

```solidity
struct Todo {
    string text;
    bool completed;
}

Todo t = Todo("aaa", false);
```

### Enums

在 `Solidity` 中，枚举是由一组有限的常量值组成的自定义数据类型。当我们的变量应该只从一组预定义的值中分配一个值时，我们使用枚举。

```solidity
// Enum representing shipping status
// Returns uint
// Pending  - 0
// Shipped  - 1
// Accepted - 2
// Rejected - 3
// Canceled - 4
enum Status {
    Pending,
    Shipped,
    Accepted,
    Rejected,
    Canceled
}

Status public status;

# 使用
status = Status.Canceled;
# 删除，将枚举重置为其第一个值 0
delete status;
```


## Data Locations

`Solidity` 中变量的值可以存储在不同的数据位置：memory, storage, and calldata。

值类型的变量存储值的独立副本，而引用类型（数组、结构体、映射）的变量仅存储值的位置（引用）。

如果在函数中使用引用类型，则必须指定它们的值存储在哪个数据位置。函数执行的价格受数据位置的影响；从引用类型创建副本会消耗 `gas`。

### Storage

存储在 `storage` 中的值永久存储在区块链上，因此使用成本昂贵。全局的引用类型的变量将存储在 `storage` 中。

### Memory

存储在 `memory` 中的值只是临时存储，并不在区块链上。它们仅在外部函数执行期间存在，并在执行后被丢弃。它们的使用成本比存储在 `storage` 中的值更便宜。

### Calldata

存储在 `calldata` 中的值只是临时存储，并不在区块链上。它们仅在外部函数执行期间存在，并在执行后被丢弃。存储在 `calldata` 的值不会被改变，`calldata` 是使用成本最低的存储方式。


## Transactions

### Ether and Wei

以太币（ETH）是一种加密货币。以太币还用于支付使用以太坊网络的费用，例如以将以太币发送到地址或与以太坊应用程序交互的形式进行交易。

要指定 `Ether` 的单位，我们可以将后缀 `wei`、`gwei` 或 `ether` 添加到数字上。

```
1 gwei = 1,000,000,000 (10^9) wei
1 ether = 1,000,000,000 (10^9) gwei
1 ether = 1,000,000,000,000,000,000 (10^18) wei
```

### Gas and Gas Price

正如在上一节中所看到的，通过以太坊网络上的交易执行代码会产生以太形式的交易费用。执行交易所需支付的费用金额取决于执行交易所花费的天然气量。

#### Gas

`Gas` 是衡量在以太坊网络上执行特定操作所需的计算量的单位。

#### Gas price

为以太坊提供燃料的天然气有时被比作为汽车提供燃料的天然气。汽车消耗的汽油量基本相同，但支付的汽油价格取决于市场。

类似地，对于与其相关的相同计算工作，交易所需的 `Gas` 量始终相同。然而，交易发送者愿意为 `Gas` 支付的价格取决于他们。`Gas` 价格较高的交易处理速度更快；`Gas` 价格非常低的交易可能根本无法进行。

发送交易时，发送者必须在执行交易时支付 `gas` 费（`gas_price * gas`）。如果执行完成后剩余 `gas`，发送者将获得退款。

`Gas` 价格以 `gwei` 表示。


#### Gas limit

发送交易时，发送者指定他们愿意支付的最大 `Gas` 量。如果他们将限制设置得太低，他们的交易可能会在完成之前耗尽燃料，从而恢复所做的任何更改。在这种情况下，`gas` 已被消耗且无法退还。


### Sending Ether

三种方式转账：

> 需要注意都是使用 `_to` 地址调用，转给谁谁调用。

#### transfer

```solidity
_to.transfer(msg.value);
```

#### send

```solidity
bool sent = _to.send(msg.value);
require(sent, "Failed to send Ether");
```

#### call

```solidity
(bool sent, bytes memory data) = _to.call{value: msg.value}("");
require(sent, "Failed to send Ether");
```

#### Payable function modifier

`payable` 函数修饰符允许函数接收 `Ether`。

#### Payable address

`Solidity` 区分了两种不同类型的地址数据类型：`address` 和 `payable address`。

address: Holds a 20-byte value. address payable: Holds a 20-byte value and can receive Ether via its members: transfer and send.
