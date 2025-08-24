use rppal::gpio::Gpio;
use std::{env, thread, time::Duration};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    // read first CLI arg as duration in seconds
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        eprintln!("Usage: cargo run <seconds>");
        std::process::exit(1);
    }
    let seconds: u64 = args[1].parse().expect("Please provide a valid number");

    // pin 17 = GPIO17 (physical pin 11)
    let mut pin = Gpio::new()?.get(17)?.into_output();

    println!("Relay ON for {} seconds...", seconds);
    // HIGH → ON
    // Since the relay switch is NORMALLY OPEN this will switch off the power
    pin.set_high();
    thread::sleep(Duration::from_secs(seconds));

    println!("Relay OFF");
    pin.set_low();

    Ok(())
}

