use core::integer::{u512, u512_safe_div_rem_by_u256};
use core::num::traits::{One, WideMul};
use wadray::{Ray, u128_rdiv, u128_rmul, Wad, WAD_DECIMALS, WAD_SCALE};


const TWO_POW_128: u256 = 0x100000000000000000000000000000000;


pub fn pow<T, impl TMul: Mul<T>, impl TOne: One<T>, impl TDrop: Drop<T>, impl TCopy: Copy<T>>(
    x: T, mut n: u8
) -> T {
    if n == 0 {
        TOne::one()
    } else if n == 1 {
        x
    } else if n % 2 == 0 {
        pow(x * x, n / 2)
    } else {
        x * pow(x * x, (n - 1) / 2)
    }
}

pub fn fixed_point_to_wad(n: u128, decimals: u8) -> Wad {
    assert(decimals <= WAD_DECIMALS, 'More than 18 decimals');
    let scale: u128 = pow(10_u128, WAD_DECIMALS - decimals);
    (n * scale).into()
}

pub fn wad_to_fixed_point(n: Wad, decimals: u8) -> u128 {
    assert(decimals <= WAD_DECIMALS, 'More than 18 decimals');
    let scale: u128 = pow(10_u128, WAD_DECIMALS - decimals);
    n.into() / scale
}

#[inline(always)]
pub fn scale_u128_by_ray(lhs: u128, rhs: Ray) -> u128 {
    u128_rmul(lhs, rhs.into())
}

#[inline(always)]
pub fn div_u128_by_ray(lhs: u128, rhs: Ray) -> u128 {
    u128_rdiv(lhs, rhs.into())
}

// If the quote token has less than 18 decimal precision, then the
// x128 value needs to be scaled up by the quote token's decimals
// https://docs.ekubo.org/integration-guides/reference/reading-pool-price
pub fn scale_x128_to_wad(n: u256, decimals: u8) -> Wad {
    let decimals_diff: u8 = WAD_DECIMALS - decimals;

    // Scale value up to Wad precision first to avoid precision loss during division
    let wad_scale: u256 = WAD_SCALE.into();
    let scaled: u256 = n * wad_scale * pow(10, decimals_diff).into();
    let sqrt: u256 = scaled / TWO_POW_128;

    // `sqrt` is of Wad precision here so the result will be of 10 ** 36 precision
    let sq: u512 = WideMul::wide_mul(sqrt, sqrt);

    // Scale the value back to Wad precision
    let (val, _) = u512_safe_div_rem_by_u256(sq, wad_scale.try_into().unwrap());

    let val: u256 = val.try_into().unwrap();
    val.try_into().unwrap()
}
