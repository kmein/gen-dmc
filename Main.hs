{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeFamilies #-}

import Data.List.Split (chunksOf)
import Diagrams.Backend.CmdLine
import Diagrams.Backend.SVG.CmdLine (mainWith, B)
import Diagrams.Prelude hiding (value)
import Options.Applicative

data StickerConfig = StickerConfig
  { textLines :: [String]
  , fontName :: String
  , backgroundColour :: Colour Double
  , textColour :: Colour Double
  , barColour :: Colour Double
  }

stickerOptions :: Parser StickerConfig
stickerOptions = do
  textLines <- chunksOf 3 <$> strArgument (metavar "TEXT")
  fontName <- strOption (long "font" <> help "Desired font for the text" <> metavar "FONT NAME" <> value "Monospace" <> showDefault)
  backgroundColour <- fromHex <$> strOption (long "background" <> long "bg" <> metavar "RGB" <> help "Desired background colour of the image" <> value "000000" <> showDefault)
  textColour <- fromHex <$> strOption (long "foreground" <> long "fg" <> metavar "RGB" <> help "Desired foreground colour of the image" <> value "ffffff" <> showDefault)
  barColour <- fromHex <$> strOption (long "frame" <> metavar "RGB" <> help "Desired top and bottom frame colour" <> value "be0a26" <> showDefault) 
  pure StickerConfig {..}
  where 
    fromHex = sRGB24read

sticker :: StickerConfig -> Diagram B
sticker StickerConfig{..} = 
  let 
    bar = rect 2.5 0.2 # fc barColour
    margin x = padX 1.05 . padY 1.05
    frameOffset
      | length textLines == 2 = 0.8
      | otherwise = 0.95
  in bg backgroundColour . margin 0.07 . center $
    vsep 0.5 
      [ bar 
      , vsep 0.8 (map text textLines) # fc textColour # font fontName # ultraBold # padY frameOffset # scaleX 1.35 
      , bar
      ]

main :: IO ()
main = do
  let optionParser = (,) <$> stickerOptions <*> ((,,) <$> parser <*> parser <*> parser)
      cliOptions = info (optionParser <**> helper) (fullDesc <> progDesc "Generate RUN DMC style images")
  (stickerConfig, diagramConfig) <- execParser cliOptions
  mainRender diagramConfig $ sticker stickerConfig
