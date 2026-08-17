import math
import os
import struct
import wave

SR = 44100


def write_wav(path: str, samples: list[float]) -> None:
    # 归一化到 16-bit
    peak = max((abs(s) for s in samples), default=1.0) or 1.0
    scale = 0.9 / peak
    with wave.open(path, "w") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        frames = bytearray()
        for s in samples:
            v = int(max(-1.0, min(1.0, s * scale)) * 32767)
            frames += struct.pack("<h", v)
        w.writeframes(bytes(frames))


def env_attack_decay(n: int, sr: int, attack: float, decay: float) -> float:
    t = n / sr
    if t < attack:
        return t / attack
    return math.exp(-(t - attack) / decay)


# —— 竹筒摇晃声：多段木签碰撞 + 低频滚动噪声 ——
def gen_shake(path: str, duration: float = 0.95) -> None:
    total = int(SR * duration)
    out = [0.0] * total
    # 整体背景：竹筒内签子互相摩擦的宽频噪声（带通感）
    rng_state = 12345

    def rnd() -> float:
        nonlocal rng_state
        rng_state = (rng_state * 1103515245 + 12345) & 0x7FFFFFFF
        return rng_state / 0x7FFFFFFF * 2 - 1

    for i in range(total):
        t = i / SR
        # 背景滚动噪声，强度随时间略增（越摇越响）
        base = rnd() * 0.05 * (0.4 + 0.6 * min(1.0, t / duration))
        out[i] += base
    # 叠加若干次"木签脆响"
    clacks = [0.08, 0.17, 0.26, 0.37, 0.46, 0.58, 0.70, 0.82]
    for c in clacks:
        start = int(c * SR)
        length = int(0.05 * SR)
        freqs = [1800 + 400 * (c % 0.3), 2600]
        for k in range(length):
            if start + k >= total:
                break
            t = k / SR
            e = math.exp(-t / 0.012)
            s = 0.0
            for f in freqs:
                s += math.sin(2 * math.pi * f * t) * e
            # 一点噪声让它像木头
            s += rnd() * e * 0.4
            out[start + k] += s * 0.5
    write_wav(path, out)


# —— 签条揭示声：明亮"叮"（多个泛音 + 快衰减）——
def gen_reveal(path: str, duration: float = 0.55) -> None:
    total = int(SR * duration)
    out = [0.0] * total
    partials = [
        (880.0, 1.0),
        (1320.0, 0.55),
        (1760.0, 0.35),
        (2640.0, 0.18),
    ]
    for i in range(total):
        t = i / SR
        # 非常短的起音 + 指数衰减
        e = math.exp(-t / 0.16)
        a = min(1.0, t / 0.006)
        s = 0.0
        for f, amp in partials:
            s += math.sin(2 * math.pi * f * t) * amp
        out[i] += s * e * a * 0.5
    write_wav(path, out)


def main() -> None:
    out_dir = os.path.join(os.path.dirname(__file__), "..", "assets", "sounds")
    os.makedirs(out_dir, exist_ok=True)
    shake = os.path.join(out_dir, "shake.wav")
    reveal = os.path.join(out_dir, "reveal.wav")
    gen_shake(shake)
    gen_reveal(reveal)
    print("wrote", os.path.abspath(shake))
    print("wrote", os.path.abspath(reveal))


if __name__ == "__main__":
    main()
