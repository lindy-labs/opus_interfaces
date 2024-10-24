pub mod IAbbot;
pub mod IAbsorber;
pub mod IAllocator;
pub mod ICaretaker;
pub mod IController;
pub mod IERC20;
pub mod IEqualizer;
pub mod IFlashBorrower;
pub mod IFlashMint;
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
pub use opus::interfaces::IFrontendDataProvider::{IFrontendDataProviderDIspatcher, IFrontendDataProviderDispatcherTrait};
pub use opus::interfaces::IShrine::{IShrineDispatcher, IShrineDispatcherTrait};

