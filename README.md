Training tesseract for Chinese
==============================

为了提高识别含有中文字符图像的准确率和速度，我们应该根据实际应用，将字符集限制在一个小的范围。不必用系统默认安装的语言文件，如简体中文`chi_sim.traineddata`

通过以下几个步骤，展示一下如何训练，以达到又快又准

1. Prepare Training text
------------------------

在我们特定的应用场景中，我们要识别的字符集有限. 假设我们要识别的图像中文字排列如下，其中N代表数字，XX代表(铜矿,铁矿,宝石,硅矿,油井)
    NN级XX Lv.NN
    坐标 (NNN.NNN)

有了以上限定，我们按照[官方][1.1]的要求，如下：
> Make sure there are a minimum number of samples of each character. 10 is good, but 5 is OK for rare characters.

样本文件命名为[chi_sim.trainint_text](chi_sim/chi_sim.training_text)

2. Training
-----------

一旦准备好了样本，我们将利用官方提供的[tesstrain.sh][1.2]来训练我们的样本.

### 准备langdata目录，目录下存放你要训练的样本 ###

由于`tesstrain.sh`需要用到langdata下的一些文件，因此langdata需从Tesseract官方的repository下载：

    $ git clone git@github.com:tesseract-ocr/langdata.git

将langdata目录下chi_sim目录下的文件删除，将[chi_sim.trainint_text](chi_sim/chi_sim.training_text)拷入langdata/chi_sim中

    $ rm -f langdata/chi_sim
    $ cp chi_sim/chi_sim.training_text langdata/chi_sim
    $ ls langdata/chi_sim
    chi_sim.training_text

### 准备字体文件 ###

由于我们在Ubuntu Linux下训练，中文字体并不是很完善，简单起见，我们直按将windows的部分字体文件拷过来即可：

    $ ls fonts/
    ARIALUNI.TTF  simfang.ttf  simsun.ttc  STFANGSO.TTF  STSONG.TTF

列出字体名称

    $ text2image --text=langdata/chi_sim/chi_sim.training_text --outputbase=chi_sim --find_fonts --fonts_dir=./fonts --min_coverage=1.0 --render_per_font=false

以上命令将可用的字体名称输出到chi_sim.fontlist.txt文件中

    $ cat chi_sim.fontlist.txt
    Arial Unicode MS
    FangSong
    NSimSun
    STFangsong
    STSong
    SimSun
    WenQuanYi Zen Hei Medium

### 调用tesstrain.sh进行训练

运行`tesstrain.sh`命令进行训练，通过--fonts_dir指定我们的字体目录和--fontlist指定我们的字体名称：

    tesstrain.sh --lang chi_sim --langdata_dir langdata --fonts_dir fonts --fontlist \
        'Arial Unicode MS' 'NSimSun' 'SimSun' 'STFangsong' 'STSong' 'FangSong' 'WenQuanYi Zen Hei Medium'
    ...
    Output /tmp/tmp.XcoPxPvPPl/chi_sim/chi_sim.traineddata created successfully.
    Creating new directory /tmp/tesstrain/tessdata
    Moving /tmp/tmp.XcoPxPvPPl/chi_sim/chi_sim.traineddata to /tmp/tesstrain/tessdata


将以上生成的traineddata拷到/usr/share/tesseract-ocr/tessdata目录下，重命名为chi.traineddata, 进行测试

    tesseract -l chi samples/1_101.bmp stdout

[1.1]: https://github.com/tesseract-ocr/tesseract/wiki/Training-Tesseract
[1.2]: https://github.com/tesseract-ocr/tesseract/wiki/Training-Tesseract-%E2%80%93-tesstrain.sh
