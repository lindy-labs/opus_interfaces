pub mod IAbbot;
pub mod IAbsorber;
pub mod IAllocator;
pub mod ICaretaker;
pub mod IController;
pub mod IERC20;
pub mod IEqualizer;
pub mod IFlashBorrower;
pub mod IFlashMint;
pub mod IFrontendDataProvider;
pub mod IGate;
pub mod IOracle;
pub mod IPragma;
pub mod IPurger;
pub mod IReceptor;
pub mod ISeer;
pub mod ISentinel;
pub mod IShrine;
pub mod ITransmuter;

pub use opus::interfaces::IAbbot::{IAbbotDispatcher, IAbbotDispatcherTrait};
pub use opus::interfaces::IAbsorber::{IAbsorberDispatcher, IAbsorberDispatcherTrait};
pub use opus::interfaces::IAllocator::{IAllocatorDispatcher, IAllocatorDispatcherTrait};
pub use opus::interfaces::ICaretaker::{ICaretakerDispatcher, ICaretakerDispatcherTrait};
pub use opus::interfaces::IController::{IControllerDispatcher, IControllerDispatcherTrait};
pub use opus::interfaces::IERC20::{IERC20Dispatcher, IERC20DispatcherTrait};
pub use opus::interfaces::IFlashBorrower::{IFlashBorrowerDispatcher, IFlashBorrowerDispatcherTrait};
pub use opus::interfaces::IFlashMint::{IFlashMintDispatcher, IFlashMintDispatcherTrait};
pub use opus::interfaces::IFrontendDataProvider::{
    IFrontendDataProviderDispatcher, IFrontendDataProviderDispatcherTrait
};
pub use opus::interfaces::IGate::{IGateDispatcher, IGateDispatcherTrait};
pub use opus::interfaces::IPragma::{IPragmaDispatcher, IPragmaDispatcherTrait};
pub use opus::interfaces::IPurger::{IPurgerDispatcher, IPurgerDispatcherTrait};
pub use opus::interfaces::IReceptor::{IReceptorDispatcher, IReceptorDispatcherTrait};
pub use opus::interfaces::ISeer::{ISeerDispatcher, ISeerDispatcherTrait};
pub use opus::interfaces::ISentinel::{ISentinelDispatcher, ISentinelDispatcherTrait};
pub use opus::interfaces::IShrine::{IShrineDispatcher, IShrineDispatcherTrait};
pub use opus::interfaces::ITransmuter::{ITransmuterDispatcher, ITransmuterDispatcherTrait};
